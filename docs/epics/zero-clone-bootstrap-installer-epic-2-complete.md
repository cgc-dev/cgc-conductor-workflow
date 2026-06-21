## EPIC 2 Complete: Update Documentation

Restructured README.md to make the curl one-liner the primary install method with explicit `--tool` examples for all four values, moved clone-then-install to an Alternative subsection, and added the bootstrap CHANGELOG entry under `[Unreleased]`.

**Files created/changed:**
- `README.md`
- `CHANGELOG.md`
- `tests/unit/test_readme_bootstrap_command.sh`
- `tests/unit/test_readme_tool_examples.sh`
- `tests/unit/test_changelog_bootstrap_entry.sh`
- `docs/epics/epic-2-update-documentation.md`
- `docs/epics-status.md`

**Functions created/changed:**
- (Documentation only — no code functions changed)

**Tests created/changed:**
- `test_readme_bootstrap_command.sh` — verifies README contains the bootstrap.sh raw URL
- `test_readme_tool_examples.sh` — verifies README documents all four `--tool` values
- `test_changelog_bootstrap_entry.sh` — verifies CHANGELOG `[Unreleased]` mentions bootstrap

**Review Status:** APPROVED

**Git Commit Message:**
```
docs: restructure README with curl one-liner and add CHANGELOG entry

- README.md: curl one-liner as primary install; clone method moved to Alternative subsection
- README.md: all four --tool values documented with examples; PowerShell equivalent included
- CHANGELOG.md: bootstrap installer entry under [Unreleased] > Added
- 3 documentation unit tests created and passing
```
