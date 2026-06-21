#!/usr/bin/env bash
# tests/unit/test_readme_tool_examples.sh
# Verifies README.md contains all four --tool values: claude, copilot, cursor, all.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
README="$REPO_ROOT/README.md"

echo "=== Test: README.md contains all four --tool values ==="

if [[ ! -f "$README" ]]; then
  echo "FAIL: README.md not found at $README"
  exit 1
fi

readme_content="$(cat "$README")"
failures=0

for tool in claude copilot cursor all; do
  if ! echo "$readme_content" | grep -q -- "--tool $tool"; then
    echo "FAIL: README.md does not contain '--tool $tool'"
    failures=$((failures + 1))
  fi
done

if [[ $failures -gt 0 ]]; then
  echo "FAIL: $failures tool value(s) missing from README.md"
  exit 1
fi

echo "PASS: README.md contains all four --tool values"
exit 0
