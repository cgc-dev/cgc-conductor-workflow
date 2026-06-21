# tests/unit/test_bootstrap_ps_invalid_tool.ps1
# Verifies bootstrap.ps1 -Tool with invalid value errors.

param()

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)
$Bootstrap = Join-Path $RepoRoot "bootstrap.ps1"

Write-Host "=== Test: bootstrap.ps1 -Tool invalid errors ==="

$prevEAP = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
$output = & powershell -NoProfile -ExecutionPolicy Bypass -File $Bootstrap -Tool invalid_tool_name 2>&1 | Out-String
$exitCode = $LASTEXITCODE
$ErrorActionPreference = $prevEAP

if ($exitCode -eq 0) {
    Write-Host "FAIL: Expected non-zero exit code for invalid tool, got 0"
    exit 1
}

if ($output -notmatch "validate|invalid|unknown|error|valid") {
    Write-Host "FAIL: Output does not contain error message about invalid tool"
    Write-Host "Output: $output"
    exit 1
}

Write-Host "PASS: bootstrap.ps1 -Tool invalid correctly errors"
exit 0
