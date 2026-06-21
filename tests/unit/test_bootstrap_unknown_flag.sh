#!/usr/bin/env bash
# tests/unit/test_bootstrap_unknown_flag.sh
# Verifies bootstrap.sh exits non-zero with a clear message on unknown flags.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BOOTSTRAP="$REPO_ROOT/bootstrap.sh"

echo "=== Test: bootstrap.sh errors on unknown flags ==="

if [[ ! -f "$BOOTSTRAP" ]]; then
  echo "SKIP: bootstrap.sh does not exist yet"
  exit 0
fi

set +e
output="$("$BOOTSTRAP" --verbose 2>&1)"
exit_code=$?
set -e

if [[ $exit_code -eq 0 ]]; then
  echo "FAIL: --verbose (unknown flag) should exit non-zero"
  exit 1
fi

if ! echo "$output" | grep -qi "unknown"; then
  echo "FAIL: Output does not mention 'unknown' for bad flag"
  echo "Output: $output"
  exit 1
fi

set +e
output2="$("$BOOTSTRAP" --foo 2>&1)"
exit_code2=$?
set -e

if [[ $exit_code2 -eq 0 ]]; then
  echo "FAIL: --foo (unknown flag) should exit non-zero"
  exit 1
fi

if ! echo "$output2" | grep -qi "unknown"; then
  echo "FAIL: Output does not mention 'unknown' for bad flag --foo"
  echo "Output: $output2"
  exit 1
fi

echo "PASS: bootstrap.sh errors on unknown flags"
exit 0
