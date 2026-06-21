#!/usr/bin/env bash
# tests/unit/test_bootstrap_invalid_tool.sh
# Verifies bootstrap.sh --tool with invalid value exits non-zero with error.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BOOTSTRAP="$REPO_ROOT/bootstrap.sh"

echo "=== Test: bootstrap.sh --tool invalid exits non-zero with error ==="

# First verify the bootstrap script exists
if [[ ! -f "$BOOTSTRAP" ]]; then
  echo "SKIP: bootstrap.sh does not exist yet"
  exit 0
fi

# Run bootstrap.sh with invalid --tool value
set +e
output="$("$BOOTSTRAP" --tool invalid_tool_name 2>&1)"
exit_code=$?
set -e

if [[ $exit_code -eq 0 ]]; then
  echo "FAIL: Expected non-zero exit code for invalid tool, got 0"
  exit 1
fi

# Verify error message mentions tool validation
if ! echo "$output" | grep -qiE "invalid.*tool|unknown.*tool|not.*valid.*tool|valid.*(claude|copilot|cursor|all)"; then
  echo "FAIL: Output does not contain an error message about invalid tool"
  echo "Output: $output"
  exit 1
fi

echo "PASS: bootstrap.sh --tool invalid correctly errors"
exit 0
