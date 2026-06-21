# claude.ps1 — Claude Code installer
function Install-Claude {
    param(
        [string]$RepoDir,
        [string]$TargetDir
    )

    $srcAgents = Join-Path $RepoDir "agents\claude\agents"
    $srcCommands = Join-Path $RepoDir "agents\claude\commands"

    Write-Host "  → Installing Claude Code agents..."

    if (Test-Path $srcAgents) {
        $dst = Join-Path $TargetDir ".claude\agents"
        New-Item -ItemType Directory -Path $dst -Force | Out-Null
        Copy-Item -Path "$srcAgents\*" -Destination $dst -Recurse -Force
        $count = (Get-ChildItem $srcAgents -Filter "*.md").Count
        Write-Host "    ✓ $count agents → .claude\agents\"
    }

    if (Test-Path $srcCommands) {
        $dst = Join-Path $TargetDir ".claude\commands"
        New-Item -ItemType Directory -Path $dst -Force | Out-Null
        Copy-Item -Path "$srcCommands\*" -Destination $dst -Recurse -Force
        $count = (Get-ChildItem $srcCommands -Filter "*.md").Count
        Write-Host "    ✓ $count commands → .claude\commands\"
    }
}
