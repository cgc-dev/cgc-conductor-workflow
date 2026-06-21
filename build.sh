#!/usr/bin/env bash
# build.sh — Generate self-contained bootstrap.sh with all files embedded (base64).
# Run whenever files under installer/ or agents/ change.
set -euo pipefail
cd "$(dirname "$0")"

OUT="bootstrap.sh"
FILES=$(find installer agents -type f | sort)
TOTAL=$(echo "$FILES" | wc -l)

cat > "$OUT" << 'HEADER'
#!/usr/bin/env bash
# bootstrap.sh — Self-contained CGC Conductor Workflow installer.
# All agent/installer files embedded. No downloads beyond this script.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/cgc-dev/cgc-conductor-workflow/main/bootstrap.sh -o bootstrap.sh && bash bootstrap.sh --tool claude
set -euo pipefail

TOOL=""
TARGET=""

cleanup() { [[ -n "${TEMP_DIR:-}" && -d "$TEMP_DIR" ]] && rm -rf "$TEMP_DIR" || true; }
trap cleanup EXIT

usage() {
  cat << 'USAGE_EOF'
CGC AI Agents -- Bootstrap Installer
Usage: ./bootstrap.sh --tool claude|copilot|cursor|all [--target /path]
USAGE_EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool) TOOL="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    --help|-h) usage ;;
    *) echo "Unknown: $1"; exit 1 ;;
  esac
done

[[ -n "$TOOL" ]] || {
  echo "Select: 1) Claude 2) Copilot 3) Cursor 4) All"
  read -rp "Choice [1-4]: " c
  case "$c" in 1) TOOL=claude;; 2) TOOL=copilot;; 3) TOOL=cursor;; 4) TOOL=all;; *) exit 1;; esac
}
case "$TOOL" in claude|copilot|cursor|all) ;; *) echo "Invalid: $TOOL"; exit 1;; esac
[[ -n "$TARGET" ]] || TARGET="$PWD"

echo "CGC Conductor Workflow -- Bootstrap Installer"
echo "Tool: $TOOL  Target: $TARGET"
echo ""

TEMP_DIR="$(mktemp -d)"

extract() {
  local path="$1" b64="$2"
  mkdir -p "$TEMP_DIR/$(dirname "$path")"
  echo "$b64" | base64 -d > "$TEMP_DIR/$path" 2>/dev/null || {
    echo "$b64" | base64 -D > "$TEMP_DIR/$path" 2>/dev/null
  }
}

HEADER

# Generate extract calls
for f in $FILES; do
  b64=$(base64 -w0 "$f" 2>/dev/null || base64 "$f" | tr -d '\n')
  echo "extract '$f' '$b64'" >> "$OUT"
done

cat >> "$OUT" << 'FOOTER'

INSTALLER="$TEMP_DIR/installer/install.sh"
chmod +x "$INSTALLER"
"$INSTALLER" --tool "$TOOL" "$TARGET"
echo "Done! Open your project in your AI tool."
rm -f "$0"
FOOTER

chmod +x "$OUT"
echo "bootstrap.sh rebuilt: $TOTAL files, $(wc -c < "$OUT" | tr -d ' ') bytes"
