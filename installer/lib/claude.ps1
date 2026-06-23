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

    $srcSettings = Join-Path $RepoDir "agents\claude\settings.json"
    if (Test-Path $srcSettings) {
        $dstSettings = Join-Path $TargetDir ".claude\settings.json"
        New-Item -ItemType Directory -Path (Join-Path $TargetDir ".claude") -Force | Out-Null
        if (-not (Test-Path $dstSettings)) {
            Copy-Item -Path $srcSettings -Destination $dstSettings
            Write-Host "    ✓ settings.json → .claude\settings.json"
        } else {
            # Merge customModes — add conductor mode if not already present
            $src = Get-Content $srcSettings -Raw | ConvertFrom-Json
            $dst = Get-Content $dstSettings -Raw | ConvertFrom-Json
            $srcModes = if ($src.customModes) { $src.customModes } else { @() }
            if (-not $dst.PSObject.Properties['customModes']) {
                $dst | Add-Member -MemberType NoteProperty -Name 'customModes' -Value @()
            }
            $existingIds = $dst.customModes | ForEach-Object { $_.id }
            $added = 0
            foreach ($mode in $srcModes) {
                if ($mode.id -notin $existingIds) {
                    $dst.customModes += $mode
                    $added++
                }
            }
            $dst | ConvertTo-Json -Depth 10 | Set-Content $dstSettings -Encoding UTF8
            if ($added -gt 0) {
                Write-Host "    ✓ settings.json merged ($added new mode(s) added)"
            } else {
                Write-Host "    ~ settings.json (conductor mode already present)"
            }
        }
    }
}
