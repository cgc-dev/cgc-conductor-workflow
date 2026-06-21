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
ARCHIVE_URL="${REPO_URL}/archive/refs/heads/main.tar.gz"
EXTRACTED_DIR="cgc-conductor-workflow-main"

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
ARCHIVE_PATH="$TEMP_DIR/archive.tar.gz"

# Detect downloader (curl preferred, wget fallback)
if command -v curl &>/dev/null; then
  echo "Downloading (curl)..."
  if ! curl -fsSL --connect-timeout 15 --max-time 120 --progress-bar "$ARCHIVE_URL" -o "$ARCHIVE_PATH"; then
    echo "Error: Failed to download from $ARCHIVE_URL"
    echo "Check your internet connection and that GitHub is reachable."
    exit 1
  fi
elif command -v wget &>/dev/null; then
  echo "Downloading (wget)..."
  if ! wget -q --show-progress --timeout=15 "$ARCHIVE_URL" -O "$ARCHIVE_PATH"; then
    echo "Error: Failed to download from $ARCHIVE_URL"
    echo "Check your internet connection and that GitHub is reachable."
    exit 1
  fi
else
  echo "Error: Neither curl nor wget found. Please install one of them."
  exit 1
fi

# Extract archive
echo "Extracting..."
if ! tar -xzf "$ARCHIVE_PATH" -C "$TEMP_DIR"; then
  echo "Error: Failed to extract archive."
  exit 1
fi

# Run the installer
INSTALLER="$TEMP_DIR/$EXTRACTED_DIR/installer/install.sh"
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
