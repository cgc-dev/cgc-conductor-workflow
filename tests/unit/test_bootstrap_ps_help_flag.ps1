# tests/unit/test_bootstrap_ps_help_flag.ps1
# Verifies bootstrap.ps1 -Help prints usage.

param()

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)
$Bootstrap = Join-Path $RepoRoot "bootstrap.ps1"

Write-Host "=== Test: bootstrap.ps1 -Help prints usage ==="

$output = & powershell -NoProfile -ExecutionPolicy Bypass -File $Bootstrap -Help 2>&1 | Out-String
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
    Write-Host "FAIL: Expected exit code 0, got $exitCode"
    exit 1
}

if ($output -notmatch "([Uu]sage|[Tt]ool|[Tt]arget|[Hh]elp)") {
    Write-Host "FAIL: -Help output does not contain usage/help text"
    Write-Host "Output: $output"
    exit 1
}

Write-Host "PASS: bootstrap.ps1 -Help works correctly"
exit 0
