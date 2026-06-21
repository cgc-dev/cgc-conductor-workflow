#!/usr/bin/env bash
# tests/unit/test_bootstrap_missing_tool_interactive.sh
# Verifies that when no --tool is given, the script prints the interactive
# menu prompt rather than erroring out silently.
# Because interactive mode requires stdin, we pipe "1" to simulate a valid choice.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BOOTSTRAP="$REPO_ROOT/bootstrap.sh"

echo "=== Test: bootstrap.sh missing tool triggers interactive prompt ==="

if [[ ! -f "$BOOTSTRAP" ]]; then
  echo "SKIP: bootstrap.sh does not exist yet"
  exit 0
fi

# Pipe "1" (Claude Code) to simulate interactive input.
# The script will try to download, which will fail in unit tests, but the
# important part is that it reaches the interactive prompt and validates.
set +e
output="$(echo "1" | "$BOOTSTRAP" 2>&1)"
exit_code=$?
set -e

# Verify the interactive menu text appears
if ! echo "$output" | grep -q "Select a tool to install:"; then
  echo "FAIL: Interactive menu prompt not found in output"
  echo "Output: $output"
  exit 1
fi

if ! echo "$output" | grep -q "Claude Code"; then
  echo "FAIL: Output does not contain menu option 'Claude Code'"
  echo "Output: $output"
  exit 1
fi

if ! echo "$output" | grep -q "GitHub Copilot"; then
  echo "FAIL: Output does not contain menu option 'GitHub Copilot'"
  echo "Output: $output"
  exit 1
fi

if [[ $exit_code -ne 0 ]]; then
  # If it fails after interactive, it should be a download/network error, not
  # a usage error. Verify the error is not "Unknown option" or "Invalid".
  if echo "$output" | grep -qiE "unknown.*option|invalid.*tool|invalid.*choice"; then
    echo "FAIL: Script errored with usage/validation error, not network error"
    echo "Output: $output"
    exit 1
  fi
  # Non-zero exit due to network is acceptable in unit test environment
  echo "NOTE: Script exited non-zero (expected: no network in unit test)"
fi

echo "PASS: bootstrap.sh missing tool triggers interactive menu"
exit 0
