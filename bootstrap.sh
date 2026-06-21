#!/usr/bin/env bash
# bootstrap.sh — Zero-clone bootstrap installer for CGC Conductor Workflow
# Downloads the repo archive to a temp directory, runs the installer, then cleans up.
#
# Usage (curl-pipe):
#   curl -fsSL https://raw.githubusercontent.com/cgc-dev/cgc-conductor-workflow/main/bootstrap.sh | bash -s -- --tool claude
#
# Usage (local):
#   ./bootstrap.sh --tool claude
#   ./bootstrap.sh --tool copilot --target /path/to/project
#   ./bootstrap.sh --help

set -euo pipefail

REPO_URL="https://github.com/cgc-dev/cgc-conductor-workflow"
RAW_URL="https://raw.githubusercontent.com/cgc-dev/cgc-conductor-workflow/main"

# File lists per tool — add new files here when the repo grows
INSTALLER_FILES=(
  "installer/install.sh"
)
CLAUDE_FILES=(
  "installer/lib/claude.sh"
  "agents/claude/agents/code-review-subagent.md"
  "agents/claude/agents/conductor.md"
  "agents/claude/agents/documentation-subagent.md"
  "agents/claude/agents/implement-subagent.md"
  "agents/claude/agents/planning-subagent.md"
  "agents/claude/agents/security-subagent.md"
  "agents/claude/agents/test-subagent.md"
  "agents/claude/commands/brainstorming.md"
  "agents/claude/commands/bug-logger.md"
  "agents/claude/commands/create-agents-md.md"
  "agents/claude/commands/excalidraw-diagram.md"
  "agents/claude/commands/executing-plans.md"
  "agents/claude/commands/frontend-design.md"
  "agents/claude/commands/spec-writer.md"
  "agents/claude/commands/update-docs.md"
  "agents/claude/commands/using-superpowers.md"
  "agents/claude/commands/verification-before-completion.md"
  "agents/claude/commands/webapp-testing.md"
  "agents/claude/commands/writing-plans.md"
)
COPILOT_FILES=(
  "installer/lib/copilot.sh"
  "agents/copilot/agents/code-review-subagent.agent.md"
  "agents/copilot/agents/Conductor.agent.md"
  "agents/copilot/agents/documentation-subagent.agent.md"
  "agents/copilot/agents/implement-subagent.agent.md"
  "agents/copilot/agents/planning-subagent.agent.md"
  "agents/copilot/agents/security-subagent.agent.md"
  "agents/copilot/agents/test-subagent.agent.md"
  "agents/copilot/prompts/brainstorm.md"
  "agents/copilot/prompts/verify.md"
  "agents/copilot/prompts/write-plan.md"
  "agents/copilot/prompts/write-spec.md"
)
CURSOR_FILES=(
  "installer/lib/cursor.sh"
  "agents/cursor/instructions/conductor-workflow.md"
  "agents/cursor/rules/code-review.mdc"
  "agents/cursor/rules/conductor.mdc"
  "agents/cursor/rules/docs.mdc"
  "agents/cursor/rules/implement.mdc"
  "agents/cursor/rules/planning.mdc"
  "agents/cursor/rules/security-review.mdc"
  "agents/cursor/rules/test.mdc"
)

TOOL=""
TARGET=""
TEMP_DIR=""

usage() {
  cat <<EOF
CGC AI Agents — Bootstrap Installer

Downloads and installs CGC Conductor Workflow agents without cloning the repo.

Usage:
  curl -fsSL ${REPO_URL}/raw/main/bootstrap.sh | bash -s -- --tool <name>
  ./bootstrap.sh --tool <name>
  ./bootstrap.sh --tool <name> --target /path/to/project
  ./bootstrap.sh --help

Options:
  --tool <name>     claude | copilot | cursor | all
  --target <path>   Install to this directory (default: current directory)
  --help, -h        Show this message

Examples:
  ./bootstrap.sh --tool claude
  ./bootstrap.sh --tool all --target ~/my-project
EOF
}

cleanup() {
  if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
    rm -rf "$TEMP_DIR"
  fi
}

trap cleanup EXIT

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool)
      TOOL="$2"
      shift 2
      ;;
    --target)
      TARGET="$2"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Run with --help for usage."
      exit 1
      ;;
  esac
done

# Validate --tool if provided before doing any network work
if [[ -n "$TOOL" ]]; then
  case "$TOOL" in
    claude|copilot|cursor|all) ;;
    *)
      echo "Error: Invalid tool '$TOOL'. Valid values: claude, copilot, cursor, all"
      exit 1
      ;;
  esac
fi

# Interactive menu if no tool specified
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

# Default target to current directory
if [[ -z "$TARGET" ]]; then
  TARGET="$PWD"
fi

echo ""
echo "CGC Conductor Workflow — Bootstrap Installer"
echo "--------------------------------------------"
echo "Tool:   $TOOL"
echo "Target: $TARGET"
echo ""

# Create temp directory
TEMP_DIR="$(mktemp -d)"

# Build the list of files to download based on tool
FILES=("${INSTALLER_FILES[@]}")
case "$TOOL" in
  claude)   FILES+=("${CLAUDE_FILES[@]}") ;;
  copilot)  FILES+=("${COPILOT_FILES[@]}") ;;
  cursor)   FILES+=("${CURSOR_FILES[@]}") ;;
  all)      FILES+=("${CLAUDE_FILES[@]}" "${COPILOT_FILES[@]}" "${CURSOR_FILES[@]}") ;;
esac

total=${#FILES[@]}
current=0

# Download each file from raw.githubusercontent.com
for file in "${FILES[@]}"; do
  current=$((current + 1))
  dest="$TEMP_DIR/$file"
  url="${RAW_URL}/${file}"
  mkdir -p "$(dirname "$dest")"
  printf "\r  [%d/%d] %s" "$current" "$total" "$file"
  if ! curl -fsSL --connect-timeout 10 --max-time 30 "$url" -o "$dest"; then
    echo ""
    echo "Error: Failed to download $file"
    exit 1
  fi
done
echo ""

# Run the installer
INSTALLER="$TEMP_DIR/installer/install.sh"
if [[ ! -f "$INSTALLER" ]]; then
  echo "Error: Installer not found at expected path: $INSTALLER"
  exit 1
fi

echo "Running installer..."
chmod +x "$INSTALLER"
"$INSTALLER" --tool "$TOOL" "$TARGET"

echo ""
echo "All done! Bootstrap installer completed successfully."
echo "Open your project in your AI tool to get started."
