#!/bin/bash
# Claude Code Team Mode Setup Uninstaller
# Removes team mode files from ~/.claude/ (keeps backups)

set -e

CLAUDE_DIR="$HOME/.claude"

echo "=== Claude Code Team Mode Uninstaller ==="
echo ""

# Remove installed files
echo "Removing team mode files..."

[ -f "$CLAUDE_DIR/agents.md" ] && rm "$CLAUDE_DIR/agents.md" && echo "  Removed agents.md"

for cmd in team status resume review finish; do
    [ -f "$CLAUDE_DIR/commands/$cmd.md" ] && rm "$CLAUDE_DIR/commands/$cmd.md" && echo "  Removed commands/$cmd.md"
done

for tmpl in decisions progress handoff; do
    [ -f "$CLAUDE_DIR/templates/$tmpl.md" ] && rm "$CLAUDE_DIR/templates/$tmpl.md" && echo "  Removed templates/$tmpl.md"
done

# Remove external agent skills
echo ""
echo "Removing external agent skills..."
[ -d "$CLAUDE_DIR/agents" ] && rm -rf "$CLAUDE_DIR/agents" && echo "  Removed agents/"
[ -d "$CLAUDE_DIR/skills" ] && rm -rf "$CLAUDE_DIR/skills" && echo "  Removed skills/"
[ -d "$CLAUDE_DIR/subagents" ] && rm -rf "$CLAUDE_DIR/subagents" && echo "  Removed subagents/"
[ -f "$CLAUDE_DIR/subagent-index.md" ] && rm "$CLAUDE_DIR/subagent-index.md" && echo "  Removed subagent-index.md"
[ -d "$CLAUDE_DIR/.external-repos" ] && rm -rf "$CLAUDE_DIR/.external-repos" && echo "  Removed .external-repos/ (cached repos)"

echo ""
echo "Note: CLAUDE.md was NOT removed (may contain other rules)."
echo "Note: Backups in $CLAUDE_DIR/backups/ were NOT removed."
echo ""
echo "=== Uninstall complete ==="
