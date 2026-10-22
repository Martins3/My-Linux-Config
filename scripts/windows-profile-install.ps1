param(
    [string]$ConfigPath,
    [string]$BackupRoot,
    [string]$ProfilePath # Only used to retire the old managed PowerShell loader.
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
if (-not $BackupRoot) {
    $BackupRoot = Join-Path $HOME ("dotfiles-backup-" + (Get-Date -Format "yyyyMMdd-HHmmss-fff"))
}
if (-not $ConfigPath) {
    $nu = Get-Command nu -CommandType Application -ErrorAction Stop
    $ConfigPath = & $nu.Source --no-config-file -c '$nu.config-path'
    if ($LASTEXITCODE -ne 0 -or -not $ConfigPath) { throw "Could not determine Nushell config path" }
}

# A loader avoids symlink privileges and keeps following files replaced by Git/editors.
$source = Join-Path $repoRoot "config\nushell\config.nu"
if (-not (Test-Path -LiteralPath $source -PathType Leaf)) { throw "Nushell config not found: $source" }
$escapedSource = $source.Replace('\', '/')
if ($escapedSource.Contains("'")) { throw "Repository paths containing single quotes are not supported by the Nu loader" }
$loader = "# Managed by dotfiles: scripts/windows-profile-install.ps1`nsource '$escapedSource'`n"
$current = $false
if (Test-Path -LiteralPath $ConfigPath) {
    $item = Get-Item -LiteralPath $ConfigPath -Force
    if ($item.PSIsContainer) { throw "Config path is a directory: $ConfigPath" }
    $current = -not $item.LinkType -and [IO.File]::ReadAllText($ConfigPath) -ceq $loader
    if (-not $current) {
        New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
        Copy-Item -LiteralPath $ConfigPath -Destination (Join-Path $BackupRoot "nu-config") -Force
        if ($item.LinkType) { Remove-Item -LiteralPath $ConfigPath -Force }
    }
}
if (-not $current) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $ConfigPath) -Force | Out-Null
    [IO.File]::WriteAllText($ConfigPath, $loader, (New-Object System.Text.UTF8Encoding($false)))
}

# Generate the official integration once; Nu loads it after config.nu.
$zoxideInit = & zoxide init nushell
if ($LASTEXITCODE -ne 0) { throw "Could not generate zoxide integration" }
$autoloadDir = Join-Path (Split-Path -Parent $ConfigPath) "autoload"
$zoxidePath = Join-Path $autoloadDir "zoxide.nu"
if (Test-Path -LiteralPath $zoxidePath) {
    New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
    Copy-Item -LiteralPath $zoxidePath -Destination (Join-Path $BackupRoot "zoxide.nu") -Force
}
New-Item -ItemType Directory -Path $autoloadDir -Force | Out-Null
[IO.File]::WriteAllText($zoxidePath, (($zoxideInit -join "`n") + "`n"), (New-Object System.Text.UTF8Encoding($false)))
Write-Output "Nushell profile ready: $ConfigPath"

# Remove only the exact loader previously installed by this repository.
if (-not $ProfilePath) {
    if ($PSVersionTable.PSVersion.Major -ge 7) {
        $ProfilePath = $PROFILE.CurrentUserCurrentHost
    } elseif ($pwsh = Get-Command pwsh -CommandType Application -ErrorAction SilentlyContinue) {
        $ProfilePath = & $pwsh.Source -NoLogo -NoProfile -Command '$PROFILE.CurrentUserCurrentHost'
        if ($LASTEXITCODE -ne 0) { throw "Could not determine the legacy PowerShell profile path" }
    }
}
if ($ProfilePath -and (Test-Path -LiteralPath $ProfilePath -PathType Leaf)) {
    $legacySource = (Join-Path $repoRoot "config\windows\pwsh.ps1").Replace("'", "''")
    $legacyLoader = "# Managed by dotfiles: scripts/windows-profile-install.ps1`n. '$legacySource'`n"
    if ([IO.File]::ReadAllText($ProfilePath).Replace("`r`n", "`n") -ceq $legacyLoader) {
        New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
        Copy-Item -LiteralPath $ProfilePath -Destination (Join-Path $BackupRoot "pwsh-profile") -Force
        Remove-Item -LiteralPath $ProfilePath -Force
        Write-Output "Retired managed PowerShell profile; backup: $BackupRoot"
    }
}
