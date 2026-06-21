# install.ps1 — copy Copilot/Claude configuration into a target project
#
# Usage:
#   .\install.ps1                        # installs into current directory
#   .\install.ps1 -Target C:\my-project
#   .\install.ps1 -Update               # re-pulls latest then installs into cwd
#
# Recommended one-time setup:
#   git clone git@github.com:YOUR-ORG/YOUR-REPO.git $HOME\.copilot-config
#   cd C:\my-project; & $HOME\.copilot-config\install.ps1

param(
    [string]$Target = (Get-Location).Path,
    [switch]$Update
)

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if ($Update) {
    Write-Host "Pulling latest configuration..."
    git -C $ScriptDir pull --ff-only
    $Target = (Get-Location).Path
}

if ((Resolve-Path $Target).Path -eq (Resolve-Path $ScriptDir).Path) {
    Write-Error "Target cannot be the config repo itself."
    exit 1
}

Write-Host ""
Write-Host "Installing Copilot configuration into: $Target"
Write-Host ""

# --- Copy directories (merge into existing) ---
foreach ($dir in @('.github', '.claude')) {
    $src = Join-Path $ScriptDir $dir
    $dst = Join-Path $Target $dir

    if (Test-Path $src) {
        if (-not (Test-Path $dst)) {
            New-Item -ItemType Directory -Path $dst -Force | Out-Null
        }
        Copy-Item -Path "$src\*" -Destination $dst -Recurse -Force
        Write-Host "  + $dir/"
    }
}

# --- Copy root config files (skip if already present) ---
foreach ($file in @('AGENTS.md', 'CLAUDE.md')) {
    $src = Join-Path $ScriptDir $file
    $dst = Join-Path $Target $file

    if (Test-Path $src) {
        if (-not (Test-Path $dst)) {
            Copy-Item -Path $src -Destination $dst
            Write-Host "  + $file"
        } else {
            Write-Host "  ~ $file (already exists — skipped; diff manually if needed)"
        }
    }
}

Write-Host ""
Write-Host "Done! Next steps:"
Write-Host "  1. Open $Target in VS Code"
Write-Host "  2. Edit CLAUDE.md and AGENTS.md to match your project"
Write-Host "  3. Remove any .github\instructions\ files for stacks you don't use"
Write-Host "  4. Run 'claude' or open GitHub Copilot Chat to start"
Write-Host ""
