# tests/unit/test_bootstrap_ps_tool_all.ps1
# Verifies bootstrap.ps1 accepts -Tool all as a valid tool value.

param()

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)
$Bootstrap = Join-Path $RepoRoot "bootstrap.ps1"

Write-Host "=== Test: bootstrap.ps1 -Tool all is accepted as valid ==="

$output = & powershell -NoProfile -ExecutionPolicy Bypass -File $Bootstrap -Tool all -Help 2>&1 | Out-String
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
    Write-Host "FAIL: -Tool all -Help exited with $exitCode (expected 0)"
    Write-Host "Output: $output"
    exit 1
}

if ($output -notmatch "([Uu]sage)") {
    Write-Host "FAIL: Output does not contain usage text"
    Write-Host "Output: $output"
    exit 1
}

Write-Host "PASS: bootstrap.ps1 -Tool all is accepted as valid"
exit 0
