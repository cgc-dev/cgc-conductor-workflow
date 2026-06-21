# bootstrap.ps1 — Zero-clone bootstrap installer for CGC Conductor Workflow (Windows PowerShell)
# Downloads the repo archive to a temp directory, runs the installer, then cleans up.
#
# Usage:
#   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/cgc-dev/cgc-conductor-workflow/main/bootstrap.ps1" | Invoke-Expression
#   .\bootstrap.ps1 -Tool claude
#   .\bootstrap.ps1 -Tool copilot -Target C:\project
#   .\bootstrap.ps1 -Help

param(
    [ValidateSet('claude', 'copilot', 'cursor', 'all', '')]
    [string]$Tool = '',
    [string]$Target = '',
    [switch]$Help
)

$ErrorActionPreference = 'Stop'
$RepoUrl = 'https://github.com/cgc-dev/cgc-conductor-workflow'
$ArchiveUrl = "https://codeload.github.com/cgc-dev/cgc-conductor-workflow/zip/refs/heads/main"
$ArchiveUrlFallback = "$RepoUrl/archive/refs/heads/main.zip"
$ExtractedDir = 'cgc-conductor-workflow-main'

if ($Help) {
    @"
CGC AI Agents -- Bootstrap Installer

Downloads and installs CGC Conductor Workflow agents without cloning the repo.

Usage:
  .\bootstrap.ps1 -Tool <name>
  .\bootstrap.ps1 -Tool <name> -Target C:\path\to\project
  .\bootstrap.ps1 -Help

Options:
  -Tool <name>     claude | copilot | cursor | all
  -Target <path>   Install to this directory (default: current directory)
  -Help            Show this message

Examples:
  .\bootstrap.ps1 -Tool claude
  .\bootstrap.ps1 -Tool all -Target C:\my-project
"@
    exit 0
}

# Interactive menu if no tool specified
if (-not $Tool) {
    Write-Host "Select a tool to install:"
    Write-Host "  1) Claude Code"
    Write-Host "  2) GitHub Copilot"
    Write-Host "  3) Cursor"
    Write-Host "  4) All"
    $choice = Read-Host "Choice [1-4]"
    switch ($choice) {
        '1' { $Tool = 'claude' }
        '2' { $Tool = 'copilot' }
        '3' { $Tool = 'cursor' }
        '4' { $Tool = 'all' }
        default { Write-Error "Invalid choice."; exit 1 }
    }
}

# Default target to current directory
if (-not $Target) {
    $Target = (Get-Location).Path
}

Write-Host "`nCGC Conductor Workflow -- Bootstrap Installer"
Write-Host "--------------------------------------------"
Write-Host "Tool:   $Tool"
Write-Host "Target: $Target"
Write-Host ""

# Create temp directory
$TempDir = Join-Path $env:TEMP "cgc-bootstrap-$([System.Guid]::NewGuid().ToString().Substring(0,8))"
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
$ArchivePath = Join-Path $TempDir "archive.zip"

try {
    # Download archive
    Write-Host "Downloading archive..."
    try {
        Invoke-WebRequest -Uri $ArchiveUrl -OutFile $ArchivePath -UseBasicParsing -TimeoutSec 120
    } catch {
        Write-Host "Primary URL failed, trying fallback..."
        Invoke-WebRequest -Uri $ArchiveUrlFallback -OutFile $ArchivePath -UseBasicParsing -TimeoutSec 120
    }

    # Extract archive
    Write-Host "Extracting..."
    Expand-Archive -Path $ArchivePath -DestinationPath $TempDir -Force

    # Find the extracted directory (GitHub wraps in repo-branch/)
    $ExtractedPath = Join-Path $TempDir $ExtractedDir
    if (-not (Test-Path $ExtractedPath)) {
        # Try to find the extracted directory when naming differs (match cgc-conductor-workflow- prefix)
        $dirs = Get-ChildItem -Path $TempDir -Directory | Where-Object { $_.Name -like 'cgc-conductor-workflow-*' } | Select-Object -First 1
        if ($dirs) { $ExtractedPath = $dirs.FullName }
    }

    $Installer = Join-Path $ExtractedPath "installer\install.ps1"
    if (-not (Test-Path $Installer)) {
        Write-Error "Installer not found at expected path: $Installer"
        exit 1
    }

    # Run the installer
    Write-Host "Running installer..."
    & powershell -NoProfile -ExecutionPolicy Bypass -File $Installer -Tool $Tool -Target $Target

    Write-Host "`nAll done! Bootstrap installer completed successfully."
    Write-Host "Open your project in your AI tool to get started."
} finally {
    # Clean up temp directory
    if (Test-Path $TempDir) {
        Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
    }
}
