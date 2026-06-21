# tests/unit/test_bootstrap_ps_missing_tool_interactive.ps1
# Verifies that when no -Tool is given, bootstrap.ps1 prints the interactive
# menu prompt rather than erroring out silently.
# Because interactive mode requires stdin, we pipe "1" to simulate a valid choice.

param()

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)
$Bootstrap = Join-Path $RepoRoot "bootstrap.ps1"

Write-Host "=== Test: bootstrap.ps1 missing tool triggers interactive prompt ==="

# Pipe "1" (Claude Code) to simulate interactive input.
# The script will try to download, which will fail in unit tests, but the
# important part is that it reaches the interactive prompt.
$prevEAP = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
$output = "1" | & powershell -NoProfile -ExecutionPolicy Bypass -File $Bootstrap 2>&1 | Out-String
$exitCode = $LASTEXITCODE
$ErrorActionPreference = $prevEAP

# Verify the interactive menu text appears
if ($output -notmatch "Select a tool to install:") {
    Write-Host "FAIL: Interactive menu prompt not found in output"
    Write-Host "Output: $output"
    exit 1
}

if ($output -notmatch "Claude Code") {
    Write-Host "FAIL: Output does not contain menu option 'Claude Code'"
    Write-Host "Output: $output"
    exit 1
}

if ($output -notmatch "GitHub Copilot") {
    Write-Host "FAIL: Output does not contain menu option 'GitHub Copilot'"
    Write-Host "Output: $output"
    exit 1
}

if ($exitCode -ne 0) {
    # If it fails after interactive, it should be a download/network error, not
    # a usage error. Verify the error is not a script-level validation message.
    if ($output -match "Invalid tool|Invalid choice|Unknown option") {
        Write-Host "FAIL: Script errored with usage/validation error, not network error"
        Write-Host "Output: $output"
        exit 1
    }
    # Non-zero exit due to network is acceptable in unit test environment
    Write-Host "NOTE: Script exited non-zero (expected: no network in unit test)"
}

Write-Host "PASS: bootstrap.ps1 missing tool triggers interactive menu"
exit 0
