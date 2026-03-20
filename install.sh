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
echo "Usage: Open any project and type '/team' to start."
echo "Backup saved to: $BACKUP_DIR"
