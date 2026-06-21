#!/usr/bin/env bash
# tests/unit/test_bootstrap_help_flag.sh
# Verifies bootstrap.sh --help prints usage and exits 0.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BOOTSTRAP="$REPO_ROOT/bootstrap.sh"

echo "=== Test: bootstrap.sh --help prints usage and exits 0 ==="

# Run bootstrap.sh with --help
output="$("$BOOTSTRAP" --help 2>&1)"
exit_code=$?

if [[ $exit_code -ne 0 ]]; then
  echo "FAIL: Expected exit code 0, got $exit_code"
  exit 1
fi

# Verify output contains key usage text
if ! echo "$output" | grep -q "Usage"; then
  echo "FAIL: --help output does not contain 'Usage'"
  echo "Output: $output"
  exit 1
fi

if ! echo "$output" | grep -q "tool"; then
  echo "FAIL: --help output does not contain 'tool'"
  echo "Output: $output"
  exit 1
fi

if ! echo "$output" | grep -q "target"; then
  echo "FAIL: --help output does not contain 'target'"
  echo "Output: $output"
  exit 1
fi

echo "PASS: bootstrap.sh --help works correctly"
exit 0
