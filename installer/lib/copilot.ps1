# copilot.ps1 — GitHub Copilot installer
function Install-Copilot {
    param(
        [string]$RepoDir,
        [string]$TargetDir
    )

    $srcAgents = Join-Path $RepoDir "agents\copilot\agents"
    $srcPrompts = Join-Path $RepoDir "agents\copilot\prompts"

    Write-Host "  → Installing GitHub Copilot agents..."

    if (Test-Path $srcAgents) {
        $dst = Join-Path $TargetDir ".github\agents"
        New-Item -ItemType Directory -Path $dst -Force | Out-Null
        Copy-Item -Path "$srcAgents\*" -Destination $dst -Recurse -Force
        $count = (Get-ChildItem $srcAgents -Filter "*.agent.md").Count
        Write-Host "    ✓ $count agents → .github\agents\"
    }

    if (Test-Path $srcPrompts) {
        $dst = Join-Path $TargetDir ".github\prompts"
        New-Item -ItemType Directory -Path $dst -Force | Out-Null
        Copy-Item -Path "$srcPrompts\*" -Destination $dst -Recurse -Force
        $count = (Get-ChildItem $srcPrompts -Filter "*.md").Count
        Write-Host "    ✓ $count prompts → .github\prompts\"
    }
}
