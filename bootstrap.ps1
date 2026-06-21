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
$RawUrl = 'https://raw.githubusercontent.com/cgc-dev/cgc-conductor-workflow/main'

# File lists per tool — add new files here when the repo grows
$InstallerFiles = @(
    "installer/install.ps1"
)
$ClaudeFiles = @(
    "installer/lib/claude.ps1"
    "agents/claude/agents/code-review-subagent.md"
    "agents/claude/agents/conductor.md"
    "agents/claude/agents/documentation-subagent.md"
    "agents/claude/agents/implement-subagent.md"
    "agents/claude/agents/planning-subagent.md"
    "agents/claude/agents/security-subagent.md"
    "agents/claude/agents/test-subagent.md"
    "agents/claude/commands/brainstorming.md"
    "agents/claude/commands/bug-logger.md"
    "agents/claude/commands/create-agents-md.md"
    "agents/claude/commands/excalidraw-diagram.md"
    "agents/claude/commands/executing-plans.md"
    "agents/claude/commands/frontend-design.md"
    "agents/claude/commands/spec-writer.md"
    "agents/claude/commands/update-docs.md"
    "agents/claude/commands/using-superpowers.md"
    "agents/claude/commands/verification-before-completion.md"
    "agents/claude/commands/webapp-testing.md"
    "agents/claude/commands/writing-plans.md"
)
$CopilotFiles = @(
    "installer/lib/copilot.ps1"
    "agents/copilot/agents/code-review-subagent.agent.md"
    "agents/copilot/agents/Conductor.agent.md"
    "agents/copilot/agents/documentation-subagent.agent.md"
    "agents/copilot/agents/implement-subagent.agent.md"
    "agents/copilot/agents/planning-subagent.agent.md"
    "agents/copilot/agents/security-subagent.agent.md"
    "agents/copilot/agents/test-subagent.agent.md"
    "agents/copilot/prompts/brainstorm.md"
    "agents/copilot/prompts/verify.md"
    "agents/copilot/prompts/write-plan.md"
    "agents/copilot/prompts/write-spec.md"
)
$CursorFiles = @(
    "installer/lib/cursor.ps1"
    "agents/cursor/instructions/conductor-workflow.md"
    "agents/cursor/rules/code-review.mdc"
    "agents/cursor/rules/conductor.mdc"
    "agents/cursor/rules/docs.mdc"
    "agents/cursor/rules/implement.mdc"
    "agents/cursor/rules/planning.mdc"
    "agents/cursor/rules/security-review.mdc"
    "agents/cursor/rules/test.mdc"
)

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

# Build the list of files to download based on tool
$Files = [System.Collections.ArrayList]::new()
[void]$Files.AddRange($InstallerFiles)
switch ($Tool) {
    'claude'  { [void]$Files.AddRange($ClaudeFiles) }
    'copilot' { [void]$Files.AddRange($CopilotFiles) }
    'cursor'  { [void]$Files.AddRange($CursorFiles) }
    'all'     { [void]$Files.AddRange($ClaudeFiles); [void]$Files.AddRange($CopilotFiles); [void]$Files.AddRange($CursorFiles) }
}

$total = $Files.Count
$current = 0

# Create temp directory
$TempDir = Join-Path $env:TEMP "cgc-bootstrap-$([System.Guid]::NewGuid().ToString().Substring(0,8))"
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

try {
    # Download each file from raw.githubusercontent.com
    foreach ($file in $Files) {
        $current++
        $dest = Join-Path $TempDir $file
        $url = "$RawUrl/$file"
        $dir = Split-Path $dest -Parent
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        Write-Host "  [$current/$total] $file"
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -TimeoutSec 30
    }

    # Run the installer
    $Installer = Join-Path $TempDir "installer\install.ps1"
    if (-not (Test-Path $Installer)) {
        Write-Error "Installer not found at expected path: $Installer"
        exit 1
    }

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
