#!/usr/bin/env bash
# tests/unit/test_bootstrap_tool_all.sh
# Verifies bootstrap.sh accepts --tool all as a valid tool value.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BOOTSTRAP="$REPO_ROOT/bootstrap.sh"

echo "=== Test: bootstrap.sh --tool all is accepted as valid ==="

if [[ ! -f "$BOOTSTRAP" ]]; then
  echo "SKIP: bootstrap.sh does not exist yet"
  exit 0
fi

# --tool all --help should exit 0 and show help (bypasses download)
output="$("$BOOTSTRAP" --tool all --help 2>&1)"
exit_code=$?

if [[ $exit_code -ne 0 ]]; then
  echo "FAIL: --tool all --help exited with $exit_code (expected 0)"
  echo "Output: $output"
  exit 1
fi

if ! echo "$output" | grep -q "Usage"; then
  echo "FAIL: Output does not contain 'Usage'"
  echo "Output: $output"
  exit 1
fi

echo "PASS: bootstrap.sh --tool all is accepted as valid"
exit 0
