# installer/install.ps1 — Multi-tool agent installer (Windows PowerShell)
# Usage:
#   .\installer\install.ps1                          # interactive menu
#   .\installer\install.ps1 -Tool claude            # Claude Code agents
#   .\installer\install.ps1 -Tool copilot           # GitHub Copilot agents
#   .\installer\install.ps1 -Tool cursor            # Cursor rules
#   .\installer\install.ps1 -Tool all               # all tools
#   .\installer\install.ps1 -Tool claude -Target C:\project

param(
    [ValidateSet('claude', 'copilot', 'cursor', 'all', '')]
    [string]$Tool = '',
    [string]$Target = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent $ScriptDir
$LibDir = Join-Path $ScriptDir "lib"

# Interactive menu if no tool specified
if (-not $Tool) {
    Write-Host "`nSelect a tool to install:"
    Write-Host "  1) Claude Code"
    Write-Host "  2) GitHub Copilot"
    Write-Host "  3) Cursor"
    Write-Host "  4) All`n"
    $choice = Read-Host "Choice [1-4]"
    switch ($choice) {
        '1' { $Tool = 'claude' }
        '2' { $Tool = 'copilot' }
        '3' { $Tool = 'cursor' }
        '4' { $Tool = 'all' }
        default { Write-Error "Invalid choice."; exit 1 }
    }
}

Write-Host "`nInstalling CGC AI Agents into: $Target"
Write-Host "Tool: $Tool`n"

switch ($Tool) {
    'claude' {
        . (Join-Path $LibDir "claude.ps1")
        Install-Claude -RepoDir $RepoDir -TargetDir $Target
    }
    'copilot' {
        . (Join-Path $LibDir "copilot.ps1")
        Install-Copilot -RepoDir $RepoDir -TargetDir $Target
    }
    'cursor' {
        . (Join-Path $LibDir "cursor.ps1")
        Install-Cursor -RepoDir $RepoDir -TargetDir $Target
    }
    'all' {
        foreach ($t in @('claude', 'copilot', 'cursor')) {
            . (Join-Path $LibDir "$t.ps1")
            & "Install-$($t.Substring(0,1).ToUpper() + $t.Substring(1))" -RepoDir $RepoDir -TargetDir $Target
        }
    }
}

Write-Host "`nDone! See agents/generic/workflow.md for the Conductor workflow."
Write-Host "Open your project in your AI tool to get started."
