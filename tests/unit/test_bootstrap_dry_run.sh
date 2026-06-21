#!/usr/bin/env bash
# tests/unit/test_bootstrap_dry_run.sh
# Verifies bootstrap.sh can parse --tool claude --help without syntax errors.
# Sources the script's usage function to validate expected output.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BOOTSTRAP="$REPO_ROOT/bootstrap.sh"

echo "=== Test: bootstrap.sh dry-run parses args without syntax errors ==="

if [[ ! -f "$BOOTSTRAP" ]]; then
  echo "SKIP: bootstrap.sh does not exist yet"
  exit 0
fi

# Verify script is executable / parseable by bash
if ! bash -n "$BOOTSTRAP"; then
  echo "FAIL: bootstrap.sh has syntax errors"
  exit 1
fi

# Run with --tool claude --help — should parse cleanly and show help
output="$("$BOOTSTRAP" --tool claude --help 2>&1)"
exit_code=$?

if [[ $exit_code -ne 0 ]]; then
  echo "FAIL: --tool claude --help exited with $exit_code (expected 0)"
  echo "Output: $output"
  exit 1
fi

# Verify help content for key sections
if ! echo "$output" | grep -q "Usage"; then
  echo "FAIL: Output does not contain 'Usage'"
  echo "Output: $output"
  exit 1
fi

if ! echo "$output" | grep -q "claude"; then
  echo "FAIL: Output does not mention 'claude' as valid tool"
  echo "Output: $output"
  exit 1
fi

echo "PASS: bootstrap.sh dry-run parses args correctly"
exit 0
