#!/usr/bin/env bash
# installer/install.sh — Multi-tool agent installer
# Installs the Conductor workflow agents into any project.
# Usage:
#   installer/install.sh                          # interactive menu
#   installer/install.sh --tool claude            # Claude Code agents + commands
#   installer/install.sh --tool copilot           # GitHub Copilot agents + prompts
#   installer/install.sh --tool cursor            # Cursor rules + instructions
#   installer/install.sh --tool all               # all available tools
#   installer/install.sh /path/to/project --tool claude

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
TARGET=""

TOOL=""
ARGS=("$@")

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool)
      TOOL="$2"
      shift 2
      ;;
    --help|-h)
      cat <<EOF
CGC AI Agents — Installer

Installs Conductor workflow agents into any project for your AI coding tool.

Usage:
  installer/install.sh                          Interactive menu
  installer/install.sh --tool <name>            Install for a specific tool
  installer/install.sh /path --tool <name>      Install into specific directory

Tools:
  claude    Claude Code agents + 12 slash commands
  copilot   GitHub Copilot agents + 4 prompt templates
  cursor    Cursor rules + Agent mode instructions
  all       All of the above
EOF
      exit 0
      ;;
    --*)
      echo "Unknown option: $1"
      exit 1
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

# Default to current directory
if [[ -z "$TARGET" ]]; then
  TARGET="$PWD"
fi

# Interactive menu if no tool
if [[ -z "$TOOL" ]]; then
  echo "Select a tool to install:"
  echo "  1) Claude Code"
  echo "  2) GitHub Copilot"
  echo "  3) Cursor"
  echo "  4) All"
  read -rp "Choice [1-4]: " choice
  case "$choice" in
    1) TOOL="claude" ;;
    2) TOOL="copilot" ;;
    3) TOOL="cursor" ;;
    4) TOOL="all" ;;
    *) echo "Invalid choice."; exit 1 ;;
  esac
fi

echo ""
echo "Installing CGC AI Agents into: $TARGET"
echo "Tool: $TOOL"
echo ""

LIB_DIR="$SCRIPT_DIR/lib"
case "$TOOL" in
  claude)
    source "$LIB_DIR/claude.sh"
    install_claude "$REPO_DIR" "$TARGET"
    ;;
  copilot)
    source "$LIB_DIR/copilot.sh"
    install_copilot "$REPO_DIR" "$TARGET"
    ;;
  cursor)
    source "$LIB_DIR/cursor.sh"
    install_cursor "$REPO_DIR" "$TARGET"
    ;;
  all)
    for t in claude copilot cursor; do
      source "$LIB_DIR/$t.sh"
      "install_$t" "$REPO_DIR" "$TARGET"
    done
    ;;
esac

echo ""
echo "Done! See agents/generic/workflow.md for the Conductor workflow."
echo "Open your project in your AI tool to get started."
