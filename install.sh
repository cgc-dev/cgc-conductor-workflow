#!/usr/bin/env bash
# install.sh — copy Copilot/Claude configuration into a target project
#
# Usage:
#   ./install.sh              # installs into current directory
#   ./install.sh /path/to/project
#   ./install.sh --update     # re-runs from a previously cloned config repo
#
# Recommended one-time setup:
#   git clone git@github.com:YOUR-ORG/YOUR-REPO.git ~/.copilot-config
#   cd ~/my-project && ~/.copilot-config/install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-$PWD}"

# Resolve --update flag (re-pull then install into cwd)
if [[ "${1:-}" == "--update" ]]; then
  echo "Pulling latest configuration..."
  git -C "$SCRIPT_DIR" pull --ff-only
  TARGET="$PWD"
fi

if [[ "$TARGET" == "$SCRIPT_DIR" ]]; then
  echo "Error: target cannot be the config repo itself."
  exit 1
fi

echo ""
echo "Installing Copilot configuration into: $TARGET"
echo ""

# --- Copy directories (merge into existing, don't wipe) ---
for dir in .github .claude; do
  src="$SCRIPT_DIR/$dir"
  dst="$TARGET/$dir"
  if [[ -d "$src" ]]; then
    mkdir -p "$dst"
    cp -r "$src/." "$dst/"
    echo "  ✓ $dir/"
  fi
done

# --- Copy root config files (skip if already present) ---
for file in AGENTS.md CLAUDE.md; do
  src="$SCRIPT_DIR/$file"
  dst="$TARGET/$file"
  if [[ -f "$src" ]]; then
    if [[ ! -f "$dst" ]]; then
      cp "$src" "$dst"
      echo "  ✓ $file"
    else
      echo "  ~ $file (already exists — skipped; diff manually if needed)"
    fi
  fi
done

echo ""
echo "Done! Next steps:"
echo "  1. Open $TARGET in VS Code"
echo "  2. Edit CLAUDE.md and AGENTS.md to match your project"
echo "  3. Remove any .github/instructions/ files for stacks you don't use"
echo "  4. Run 'claude' or open GitHub Copilot Chat to start"
echo ""
