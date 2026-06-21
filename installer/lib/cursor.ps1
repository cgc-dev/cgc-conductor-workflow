# cursor.ps1 — Cursor installer
function Install-Cursor {
    param(
        [string]$RepoDir,
        [string]$TargetDir
    )

    $srcRules = Join-Path $RepoDir "agents\cursor\rules"
    $srcInstructions = Join-Path $RepoDir "agents\cursor\instructions"

    Write-Host "  → Installing Cursor rules..."

    if (Test-Path $srcRules) {
        $dst = Join-Path $TargetDir ".cursor\rules"
        New-Item -ItemType Directory -Path $dst -Force | Out-Null
        Copy-Item -Path "$srcRules\*" -Destination $dst -Recurse -Force
        $count = (Get-ChildItem $srcRules -Filter "*.mdc").Count
        Write-Host "    ✓ $count rules → .cursor\rules\"
    }

    if (Test-Path $srcInstructions) {
        $dst = Join-Path $TargetDir ".cursor\instructions"
        New-Item -ItemType Directory -Path $dst -Force | Out-Null
        Copy-Item -Path "$srcInstructions\*" -Destination $dst -Recurse -Force
        $count = (Get-ChildItem $srcInstructions -Filter "*.md").Count
        Write-Host "    ✓ $count instruction files → .cursor\instructions\"
    }
}
