#!/usr/bin/env bash
# tests/unit/test_bootstrap_h_short_flag.sh
# Verifies bootstrap.sh -h works as alias for --help.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BOOTSTRAP="$REPO_ROOT/bootstrap.sh"

echo "=== Test: bootstrap.sh -h prints help (short flag alias) ==="

if [[ ! -f "$BOOTSTRAP" ]]; then
  echo "SKIP: bootstrap.sh does not exist yet"
  exit 0
fi

output="$("$BOOTSTRAP" -h 2>&1)"
exit_code=$?

if [[ $exit_code -ne 0 ]]; then
  echo "FAIL: -h exited with $exit_code (expected 0)"
  echo "Output: $output"
  exit 1
fi

if ! echo "$output" | grep -q "Usage"; then
  echo "FAIL: -h output does not contain 'Usage'"
  echo "Output: $output"
  exit 1
fi

echo "PASS: bootstrap.sh -h works as --help alias"
exit 0
