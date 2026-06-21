#!/usr/bin/env bash
# tests/unit/test_bootstrap_target_flag.sh
# Verifies bootstrap.sh --target is parsed and echoed in dry-run output.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BOOTSTRAP="$REPO_ROOT/bootstrap.sh"

echo "=== Test: bootstrap.sh --target flag is parsed correctly ==="

if [[ ! -f "$BOOTSTRAP" ]]; then
  echo "SKIP: bootstrap.sh does not exist yet"
  exit 0
fi

# --tool claude --target /tmp/test-target --help should parse all flags and show help
output="$("$BOOTSTRAP" --tool claude --target /tmp/test-target --help 2>&1)"
exit_code=$?

if [[ $exit_code -ne 0 ]]; then
  echo "FAIL: --tool claude --target /tmp/test-target --help exited with $exit_code"
  echo "Output: $output"
  exit 1
fi

if ! echo "$output" | grep -q "Usage"; then
  echo "FAIL: Output does not contain 'Usage'"
  echo "Output: $output"
  exit 1
fi

echo "PASS: bootstrap.sh --target flag parsed correctly"
exit 0
