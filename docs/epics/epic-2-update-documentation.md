## EPIC 2: Update Documentation

**Plan:** `docs/plans/zero-clone-bootstrap-installer-plan.md`

### Objective

Make the curl one-liner the primary install method in README.md. Move the "clone then install" flow to an "Alternative" section. Add CHANGELOG entry for the bootstrap scripts.

### Tests to Write

1. `tests/unit/test_readme_bootstrap_command.sh` — verifies README.md contains the bootstrap one-liner URL
2. `tests/unit/test_readme_tool_examples.sh` — verifies README.md contains all four `--tool` values (`claude`, `copilot`, `cursor`, `all`)
3. `tests/unit/test_changelog_bootstrap_entry.sh` — verifies CHANGELOG.md contains the bootstrap entry under `[Unreleased]`

### Files to Modify

1. `README.md` — Restructure install section with curl one-liner as primary
2. `CHANGELOG.md` — Add bootstrap entry under `[Unreleased]`

### Tasks

#### Task Status

| Task | Completion Rate | Status | Notes/Remarks |
|------|------------------|--------|---------------|
| Restructure README.md install section | 100% | Completed | curl one-liner primary; clone flow moved to Alternative subsection; all four --tool values shown with examples; PowerShell equivalent included |
| Add CHANGELOG entry for bootstrap scripts | 100% | Completed | Entry under [Unreleased] > Added: "Zero-clone bootstrap installer..." |
| Write and run documentation tests | 100% | Completed | 3 test files: test_readme_bootstrap_command.sh, test_readme_tool_examples.sh, test_changelog_bootstrap_entry.sh — all passing |

### Repository URL

`https://github.com/cgc-dev/cgc-conductor-workflow`
