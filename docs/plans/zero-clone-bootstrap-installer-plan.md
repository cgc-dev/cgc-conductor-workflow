## Plan: Zero-Clone Bootstrap Installer

Enable developers to install the CGC Conductor Workflow into any project with a single curl-pipe-to-bash command — no git clone required. The bootstrap script downloads the repo archive from GitHub, extracts it to a temp directory, and delegates to the existing installer.

**EPICs (2 EPICs)**

1. **EPIC 1: Create Bootstrap Scripts**
   - **Objective:** Create `bootstrap.sh` (bash) and `bootstrap.ps1` (PowerShell) that download the repo archive from GitHub, extract to a temp directory, run `installer/install.sh` (or `.ps1`) with forwarded `--tool` and `--target` flags, then clean up.
   - **Files/Functions to Modify/Create:**
     - `bootstrap.sh` — new: curl-pipeable entry point for bash
     - `bootstrap.ps1` — new: irm/iex entry point for PowerShell
   - **Tests to Write:**
     - `test_bootstrap_help_flag` — verifies `--help` prints usage and exits 0
     - `test_bootstrap_invalid_tool` — verifies invalid `--tool` value exits non-zero with message
     - `test_bootstrap_dry_run` — verifies script reaches the archive download step without errors
     - `test_bootstrap_missing_tool_interactive` — verifies interactive menu launches when no `--tool` given (stdin check)
   - **Tasks:**
     1. Write `bootstrap.sh` with flag parsing, archive download (curl/wget fallback), temp extraction, delegation to `installer/install.sh`, and cleanup
     2. Write `bootstrap.ps1` with equivalent logic using `Invoke-WebRequest` and `Expand-Archive`
     3. Write tests and validate both scripts pass

2. **EPIC 2: Update Documentation**
   - **Objective:** Make the curl one-liner the primary install method in README.md. Move the "clone then install" flow to an "Alternative" section. Add CHANGELOG entry.
   - **Files/Functions to Modify/Create:**
     - `README.md` — restructure install section, add examples for all `--tool` values
     - `CHANGELOG.md` — add `Added` entry
   - **Tests to Write:**
     - `test_readme_contains_bootstrap_command` — verifies the one-liner is present in README
     - `test_readme_contains_tool_examples` — verifies `--tool claude|copilot|cursor|all` examples exist
   - **Tasks:**
     1. Rewrite README install section with bootstrap one-liner as primary
     2. Add CHANGELOG entry
     3. Verify docs are complete and examples are copy-pasteable

**Open Questions:**
1. None remaining — all design decisions confirmed.
