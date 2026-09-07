param(
    [string]$BackupRoot
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$source = Join-Path $repoRoot "config\windows\terminal.json"
$targetDir = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$target = Join-Path $targetDir "settings.json"

if (-not (Test-Path -LiteralPath $source)) {
    throw "Windows Terminal config not found: $source"
}

if (-not $BackupRoot) {
    $BackupRoot = Join-Path $HOME ("dotfiles-backup-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
}

if (Test-Path -LiteralPath $target) {
    $sourceHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
    $targetHash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash
    if ($sourceHash -eq $targetHash) {
        Write-Output "Windows Terminal config already current: $target"
        return
    }

    New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
    Copy-Item -LiteralPath $target -Destination (Join-Path $BackupRoot "terminal-settings.json") -Force
    Write-Output "Backed up $target"
}

New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
Copy-Item -LiteralPath $source -Destination $target -Force
Write-Output "Restored Windows Terminal config: $target"
Write-Output "Restart Windows Terminal to apply the change."
