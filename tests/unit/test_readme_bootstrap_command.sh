#!/usr/bin/env bash
# tests/unit/test_readme_bootstrap_command.sh
# Verifies README.md contains the bootstrap one-liner URL.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
README="$REPO_ROOT/README.md"

echo "=== Test: README.md contains the bootstrap one-liner URL ==="

if [[ ! -f "$README" ]]; then
  echo "FAIL: README.md not found at $README"
  exit 1
fi

# The bootstrap one-liner should reference the raw GitHub URL for bootstrap.sh
readme_content="$(cat "$README")"

if ! echo "$readme_content" | grep -q "raw.githubusercontent.com/cgc-dev/cgc-conductor-workflow/main/bootstrap.sh"; then
  echo "FAIL: README.md does not contain the bootstrap.sh one-liner URL"
  echo "Expected: raw.githubusercontent.com/cgc-dev/cgc-conductor-workflow/main/bootstrap.sh"
  exit 1
fi

echo "PASS: README.md contains the bootstrap one-liner URL"
exit 0
