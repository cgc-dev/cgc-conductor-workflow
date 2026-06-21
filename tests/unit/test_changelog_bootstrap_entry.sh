#!/usr/bin/env bash
# tests/unit/test_changelog_bootstrap_entry.sh
# Verifies CHANGELOG.md contains the bootstrap entry under [Unreleased].

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CHANGELOG="$REPO_ROOT/CHANGELOG.md"

echo "=== Test: CHANGELOG.md contains bootstrap entry under [Unreleased] ==="

if [[ ! -f "$CHANGELOG" ]]; then
  echo "FAIL: CHANGELOG.md not found at $CHANGELOG"
  exit 1
fi

changelog_content="$(cat "$CHANGELOG")"

# The bootstrap entry should mention "bootstrap" under the [Unreleased] section
# Extract content between [Unreleased] and the next section header
unreleased_section="$(echo "$changelog_content" | sed -n '/^## \[Unreleased\]/,/^## \[/p')"

if ! echo "$unreleased_section" | grep -qi "bootstrap"; then
  echo "FAIL: CHANGELOG.md [Unreleased] section does not mention bootstrap"
  echo "Unreleased section content:"
  echo "$unreleased_section"
  exit 1
fi

echo "PASS: CHANGELOG.md contains bootstrap entry under [Unreleased]"
exit 0
