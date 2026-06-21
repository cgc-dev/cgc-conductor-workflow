## EPIC 1 Complete: Create Bootstrap Scripts

Created `bootstrap.sh` (bash) and `bootstrap.ps1` (PowerShell) — zero-clone bootstrap scripts that download the repo archive from `https://github.com/cgc-dev/cgc-conductor-workflow`, extract to a temp directory, delegate to the existing `installer/install.sh` (or `.ps1`) with forwarded `--tool` and `--target` flags, and clean up. Users can now install the Conductor workflow with a single curl command.

**Files created/changed:**
- `bootstrap.sh`
- `bootstrap.ps1`
- `tests/unit/test_bootstrap_help_flag.sh`
- `tests/unit/test_bootstrap_invalid_tool.sh`
- `tests/unit/test_bootstrap_dry_run.sh`
- `tests/unit/test_bootstrap_missing_tool_interactive.sh`
- `tests/unit/test_bootstrap_tool_all.sh`
- `tests/unit/test_bootstrap_h_short_flag.sh`
- `tests/unit/test_bootstrap_target_flag.sh`
- `tests/unit/test_bootstrap_unknown_flag.sh`
- `tests/unit/test_bootstrap_ps_help_flag.ps1`
- `tests/unit/test_bootstrap_ps_invalid_tool.ps1`
- `tests/unit/test_bootstrap_ps_tool_all.ps1`
- `tests/unit/test_bootstrap_ps_missing_tool_interactive.ps1`
- `docs/epics/epic-1-zero-clone-bootstrap-installer.md`
- `docs/epics-status.md`

**Functions created/changed:**
- `bootstrap.sh` — flag parsing (`--tool`, `--target`, `--help`/`-h`), archive download with curl/wget fallback, temp extraction, delegation to `installer/install.sh`, trap-based cleanup
- `bootstrap.ps1` — equivalent PowerShell logic with `Invoke-WebRequest`, `Expand-Archive`, `try/finally` cleanup

**Tests created/changed:**
- 12 unit tests covering: `--help`, `-h`, `--tool` validation (valid/invalid/all), `--target`, unknown flags, interactive mode (bash + PowerShell)

**Review Status:** APPROVED

**Git Commit Message:**
```
feat: add zero-clone bootstrap installer scripts

- bootstrap.sh: curl-pipeable bash entry point with --tool/--target/--help flags
- bootstrap.ps1: PowerShell equivalent with Invoke-WebRequest/Expand-Archive
- Downloads repo archive from GitHub, extracts to temp, delegates to installer
- 12 unit tests covering flag parsing, validation, and interactive mode
```
