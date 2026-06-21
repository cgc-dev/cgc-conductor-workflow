## EPIC 1: Create Bootstrap Scripts

**Plan:** `docs/plans/zero-clone-bootstrap-installer-plan.md`

### Objective

Create `bootstrap.sh` (bash) and `bootstrap.ps1` (PowerShell) that download the repo archive from `https://github.com/cgc-dev/cgc-conductor-workflow`, extract to a temp directory, run the existing `installer/install.sh` (or `installer/install.ps1`) with forwarded `--tool` and `--target` flags, then clean up.

### Tests to Write

1. `tests/unit/test_bootstrap_help_flag.sh` — verifies `--help` prints usage and exits 0
2. `tests/unit/test_bootstrap_invalid_tool.sh` — verifies invalid `--tool` value exits non-zero with error
3. `tests/unit/test_bootstrap_ps_help_flag.ps1` — verifies `-Help` prints usage (PowerShell)
4. `tests/unit/test_bootstrap_ps_invalid_tool.ps1` — verifies invalid `-Tool` value errors (PowerShell)
5. `tests/unit/test_bootstrap_dry_run.sh` — verifies script parses `--tool claude --help` without crashing (syntax/sourcing check)
6. `tests/unit/test_bootstrap_missing_tool_interactive.sh` — verifies missing `--tool` triggers interactive prompt

### Files/Functions to Modify/Create

1. `bootstrap.sh` — Curl-pipeable bash script
2. `bootstrap.ps1` — PowerShell equivalent
3. `tests/unit/test_bootstrap_help_flag.sh`
4. `tests/unit/test_bootstrap_invalid_tool.sh`
5. `tests/unit/test_bootstrap_ps_help_flag.ps1`
6. `tests/unit/test_bootstrap_ps_invalid_tool.ps1`
7. `tests/unit/test_bootstrap_dry_run.sh`
8. `tests/unit/test_bootstrap_missing_tool_interactive.sh`

### Tasks

#### Task Status

| Task | Completion Rate | Status | Notes/Remarks |
|------|------------------|--------|---------------|
| Write `bootstrap.sh` | 100% | Completed | Bash entry point: flag parsing, archive download (curl/wget fallback), temp extraction, delegation to installer/install.sh, cleanup |
| Write `bootstrap.ps1` | 100% | Completed | PowerShell entry point: flag parsing, Invoke-WebRequest download, Expand-Archive extraction, delegation to installer\install.ps1, cleanup |
| Write `test_bootstrap_help_flag.sh` | 100% | Completed | Verifies --help prints usage and exits 0 |
| Write `test_bootstrap_invalid_tool.sh` | 100% | Completed | Verifies invalid --tool value exits non-zero with error |
| Write `test_bootstrap_ps_help_flag.ps1` | 100% | Completed | Verifies -Help prints usage (PowerShell) |
| Write `test_bootstrap_ps_invalid_tool.ps1` | 100% | Completed | Verifies invalid -Tool value errors (PowerShell) |
| Write `test_bootstrap_dry_run.sh` | 100% | Completed | Verifies script parses args and reaches download step without syntax errors |
| Write `test_bootstrap_missing_tool_interactive.sh` | 100% | Completed | Verifies missing --tool triggers interactive prompt |
| Fix EPIC file format to follow EPIC style guide | 100% | Completed | Added Tests to Write, Tasks, Task Status nesting, renamed Files to Create |
| Fix bootstrap.sh usage() to document -h | 100% | Completed | Added -h to usage() documentation |
| Fix bootstrap.ps1 fallback directory detection | 100% | Completed | Match directories starting with cgc-conductor-workflow- |

### Repository URL

`https://github.com/cgc-dev/cgc-conductor-workflow`
