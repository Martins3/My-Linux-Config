param(
    [switch]$SkipPackages,
    [switch]$SkipNeovimSync
)

$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$installer = Join-Path $repoRoot "scripts\windows-install.ps1"

& $installer @PSBoundParameters
