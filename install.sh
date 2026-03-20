#!/bin/bash
# Claude Code Team Mode Setup Installer
# Installs team mode configuration to ~/.claude/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "=== Claude Code Team Mode Setup Installer ==="
echo ""

# Check if ~/.claude exists
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "Error: $CLAUDE_DIR does not exist. Is Claude Code installed?"
    exit 1
fi

# Backup existing files
BACKUP_DIR="$CLAUDE_DIR/backups/team-mode-$(date +%Y%m%d%H%M%S)"
echo "Creating backup at: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

[ -f "$CLAUDE_DIR/CLAUDE.md" ] && cp "$CLAUDE_DIR/CLAUDE.md" "$BACKUP_DIR/"
[ -f "$CLAUDE_DIR/agents.md" ] && cp "$CLAUDE_DIR/agents.md" "$BACKUP_DIR/"
[ -d "$CLAUDE_DIR/commands" ] && cp -r "$CLAUDE_DIR/commands" "$BACKUP_DIR/"
[ -d "$CLAUDE_DIR/templates" ] && cp -r "$CLAUDE_DIR/templates" "$BACKUP_DIR/"

echo "Backup complete."
echo ""

# Install files
echo "Installing CLAUDE.md (global router)..."
cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"

echo "Installing agents.md (agent registry)..."
cp "$SCRIPT_DIR/agents.md" "$CLAUDE_DIR/agents.md"

echo "Installing commands..."
mkdir -p "$CLAUDE_DIR/commands"
for cmd in "$SCRIPT_DIR/commands/"*.md; do
    filename=$(basename "$cmd")
    cp "$cmd" "$CLAUDE_DIR/commands/$filename"
    echo "  - /$(basename "$filename" .md)"
done

echo "Installing templates..."
mkdir -p "$CLAUDE_DIR/templates"
for tmpl in "$SCRIPT_DIR/templates/"*.md; do
    filename=$(basename "$tmpl")
    cp "$tmpl" "$CLAUDE_DIR/templates/$filename"
    echo "  - $filename"
done

# Install external agent skills
echo ""
echo "=== Installing External Agent Skills ==="
echo ""

# Check git
if ! command -v git &> /dev/null; then
    echo "Warning: git not found. Skipping external skill installation."
    echo "Install git and re-run, or manually clone the repos below."
else
    SKILL_DIR="$CLAUDE_DIR/skills"
    AGENT_DIR="$CLAUDE_DIR/agents"
    EXTERNAL_DIR="$CLAUDE_DIR/.external-repos"
    mkdir -p "$SKILL_DIR" "$AGENT_DIR" "$EXTERNAL_DIR"

    # 1. agency-agents (https://github.com/msitarzewski/agency-agents)
    echo "Installing agency-agents..."
    if [ -d "$EXTERNAL_DIR/agency-agents" ]; then
        echo "  Updating existing repo..."
        git -C "$EXTERNAL_DIR/agency-agents" pull --quiet 2>/dev/null || echo "  Warning: pull failed, using existing version"
    else
        git clone --quiet https://github.com/msitarzewski/agency-agents.git "$EXTERNAL_DIR/agency-agents" 2>/dev/null || {
            echo "  Error: Failed to clone agency-agents. Check network connection."
        }
    fi
    if [ -d "$EXTERNAL_DIR/agency-agents" ]; then
        cp -r "$EXTERNAL_DIR/agency-agents/"*.md "$AGENT_DIR/" 2>/dev/null
        # Copy agent subdirectories if they exist
        for dir in "$EXTERNAL_DIR/agency-agents/"/*/; do
            [ -d "$dir" ] && [ "$(basename "$dir")" != ".git" ] && [ "$(basename "$dir")" != "scripts" ] && \
                cp -r "$dir" "$AGENT_DIR/" 2>/dev/null
        done
        echo "  Done. Agents installed to $AGENT_DIR/"
    fi

    # 2. awesome-claude-skills (https://github.com/ComposioHQ/awesome-claude-skills)
    echo "Installing awesome-claude-skills..."
    if [ -d "$EXTERNAL_DIR/awesome-claude-skills" ]; then
        echo "  Updating existing repo..."
        git -C "$EXTERNAL_DIR/awesome-claude-skills" pull --quiet 2>/dev/null || echo "  Warning: pull failed, using existing version"
    else
        git clone --quiet https://github.com/ComposioHQ/awesome-claude-skills.git "$EXTERNAL_DIR/awesome-claude-skills" 2>/dev/null || {
            echo "  Error: Failed to clone awesome-claude-skills. Check network connection."
        }
    fi
    if [ -d "$EXTERNAL_DIR/awesome-claude-skills" ]; then
        # Copy skill directories (each skill has its own folder with SKILL.md)
        for skill in "$EXTERNAL_DIR/awesome-claude-skills/"*/; do
            skill_name="$(basename "$skill")"
            [ "$skill_name" = ".git" ] && continue
            [ "$skill_name" = "node_modules" ] && continue
            [ -d "$skill" ] && cp -r "$skill" "$SKILL_DIR/" 2>/dev/null
        done
        echo "  Done. Skills installed to $SKILL_DIR/"
    fi

    echo ""
    echo "External repos cached at: $EXTERNAL_DIR/"
    echo "Re-run install.sh to update to latest versions."
fi

echo ""
echo "=== Installation complete ==="
echo ""
echo "Available commands:"
echo "  /team    - Start team mode"
echo "  /status  - Check current progress"
echo "  /resume  - Resume interrupted session"
echo "  /review  - Trigger code review"
echo "  /finish  - Finalize and merge"
echo ""
echo "Installed external skills:"
echo "  - agency-agents  → ~/.claude/agents/"
echo "  - claude-skills  → ~/.claude/skills/"
echo ""
echo "Usage: Open any project and type '/team' to start."
echo "Backup saved to: $BACKUP_DIR"
