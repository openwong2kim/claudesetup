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

    # 3. awesome-claude-code-subagents (https://github.com/VoltAgent/awesome-claude-code-subagents)
    SUBAGENT_DIR="$CLAUDE_DIR/subagents"
    mkdir -p "$SUBAGENT_DIR"
    echo "Installing awesome-claude-code-subagents..."
    if [ -d "$EXTERNAL_DIR/awesome-claude-code-subagents" ]; then
        echo "  Updating existing repo..."
        git -C "$EXTERNAL_DIR/awesome-claude-code-subagents" pull --quiet 2>/dev/null || echo "  Warning: pull failed, using existing version"
    else
        git clone --quiet https://github.com/VoltAgent/awesome-claude-code-subagents.git "$EXTERNAL_DIR/awesome-claude-code-subagents" 2>/dev/null || {
            echo "  Error: Failed to clone awesome-claude-code-subagents. Check network connection."
        }
    fi
    if [ -d "$EXTERNAL_DIR/awesome-claude-code-subagents" ]; then
        # Copy category directories and agent definitions
        for dir in "$EXTERNAL_DIR/awesome-claude-code-subagents/"*/; do
            dir_name="$(basename "$dir")"
            [ "$dir_name" = ".git" ] && continue
            [ "$dir_name" = ".github" ] && continue
            [ "$dir_name" = "node_modules" ] && continue
            [ -d "$dir" ] && cp -r "$dir" "$SUBAGENT_DIR/" 2>/dev/null
        done
        # Copy root-level .md files (README, etc.)
        cp -r "$EXTERNAL_DIR/awesome-claude-code-subagents/"*.md "$SUBAGENT_DIR/" 2>/dev/null
        echo "  Done. Subagents installed to $SUBAGENT_DIR/"
    fi

    # 4. Auto-generate subagent index from installed files
    echo ""
    echo "=== Generating Subagent Index ==="
    INDEX_FILE="$CLAUDE_DIR/subagent-index.md"
    {
        echo "# Subagent Index (Auto-Generated)"
        echo "> 이 파일은 install.sh가 자동 생성합니다. 직접 수정하지 마세요."
        echo "> 생성일: $(date '+%Y-%m-%d %H:%M:%S')"
        echo ""

        # Parse VoltAgent subagent .md files (YAML frontmatter: name, description)
        if [ -d "$SUBAGENT_DIR" ]; then
            echo "## Available Subagent Types"
            echo "| name | description | source |"
            echo "|------|-------------|--------|"
            find "$SUBAGENT_DIR" -name "*.md" -type f | sort | while read -r mdfile; do
                # Skip README, CONTRIBUTING, etc.
                fname="$(basename "$mdfile" .md)"
                case "$fname" in
                    README|CONTRIBUTING|LICENSE|CLAUDE|CHANGELOG) continue ;;
                esac
                # Extract name and description from YAML frontmatter
                sa_name=""
                sa_desc=""
                in_frontmatter=false
                while IFS= read -r line; do
                    if [ "$line" = "---" ]; then
                        if [ "$in_frontmatter" = true ]; then
                            break
                        else
                            in_frontmatter=true
                            continue
                        fi
                    fi
                    if [ "$in_frontmatter" = true ]; then
                        case "$line" in
                            name:*) sa_name="$(echo "$line" | sed 's/^name:[[:space:]]*//')" ;;
                            description:*) sa_desc="$(echo "$line" | sed 's/^description:[[:space:]]*//' | cut -c1-80)" ;;
                        esac
                    fi
                done < "$mdfile"
                # Fallback: use filename as name
                [ -z "$sa_name" ] && sa_name="$fname"
                [ -n "$sa_name" ] && echo "| $sa_name | $sa_desc | subagents |"
            done
        fi

        # Parse agency-agents (folder-based agents)
        if [ -d "$AGENT_DIR" ]; then
            echo ""
            echo "## Agency Agents"
            echo "| name | source |"
            echo "|------|--------|"
            find "$AGENT_DIR" -name "*.md" -type f | sort | while read -r mdfile; do
                fname="$(basename "$mdfile" .md)"
                case "$fname" in
                    README|CONTRIBUTING|LICENSE|CLAUDE|CHANGELOG) continue ;;
                esac
                echo "| $fname | agents |"
            done
        fi

        # Parse skills (folder-based, look for SKILL.md)
        if [ -d "$SKILL_DIR" ]; then
            echo ""
            echo "## Skills"
            echo "| name | description | source |"
            echo "|------|-------------|--------|"
            for skill_dir in "$SKILL_DIR"/*/; do
                [ ! -d "$skill_dir" ] && continue
                skill_name="$(basename "$skill_dir")"
                skill_desc=""
                # Try to read description from SKILL.md frontmatter
                if [ -f "$skill_dir/SKILL.md" ]; then
                    in_frontmatter=false
                    while IFS= read -r line; do
                        if [ "$line" = "---" ]; then
                            if [ "$in_frontmatter" = true ]; then
                                break
                            else
                                in_frontmatter=true
                                continue
                            fi
                        fi
                        if [ "$in_frontmatter" = true ]; then
                            case "$line" in
                                description:*) skill_desc="$(echo "$line" | sed 's/^description:[[:space:]]*//' | cut -c1-80)" ;;
                            esac
                        fi
                    done < "$skill_dir/SKILL.md"
                fi
                echo "| $skill_name | $skill_desc | skills |"
            done
        fi
    } > "$INDEX_FILE"

    # Count entries
    subagent_count=$(grep -c "| .* | .* | subagents |" "$INDEX_FILE" 2>/dev/null || echo "0")
    agent_count=$(grep -c "| .* | agents |" "$INDEX_FILE" 2>/dev/null || echo "0")
    skill_count=$(grep -c "| .* | .* | skills |" "$INDEX_FILE" 2>/dev/null || echo "0")
    echo "  Generated: $INDEX_FILE"
    echo "  Subagents: $subagent_count | Agents: $agent_count | Skills: $skill_count"

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
echo "  - agency-agents       → ~/.claude/agents/"
echo "  - claude-skills       → ~/.claude/skills/"
echo "  - claude-subagents    → ~/.claude/subagents/"
echo ""
echo "Usage: Open any project and type '/team' to start."
echo "Backup saved to: $BACKUP_DIR"
