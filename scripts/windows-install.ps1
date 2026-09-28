param(
    [switch]$SkipPackages,
    [switch]$SkipNeovimSync
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

function Invoke-NativeCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(Mandatory = $true)]
        [string[]]$ArgumentList
    )

    & $FilePath @ArgumentList
    if ($LASTEXITCODE -ne 0) {
        throw "$FilePath failed with exit code $LASTEXITCODE"
    }
}

function Test-SamePath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$First,

        [Parameter(Mandatory = $true)]
        [string]$Second
    )

    $firstPath = [IO.Path]::GetFullPath($First).TrimEnd("\")
    $secondPath = [IO.Path]::GetFullPath($Second).TrimEnd("\")
    return $firstPath.Equals($secondPath, [StringComparison]::OrdinalIgnoreCase)
}

$script:backupRoot = Join-Path $HOME ("dotfiles-backup-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
$script:backupCreated = $false

function Backup-Item {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return
    }
    if (-not $script:backupCreated) {
        New-Item -ItemType Directory -Path $script:backupRoot -Force | Out-Null
        $script:backupCreated = $true
    }

    Copy-Item -LiteralPath $Path -Destination (Join-Path $script:backupRoot $Name) -Recurse -Force
    Write-Output "Backed up $Path"
}

function Install-Junction {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Source,

        [Parameter(Mandatory = $true)]
        [string]$Target,

        [Parameter(Mandatory = $true)]
        [string]$BackupName
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Junction source not found: $Source"
    }

    if (Test-Path -LiteralPath $Target) {
        $item = Get-Item -LiteralPath $Target -Force
        $itemTarget = $item.Target | Select-Object -First 1
        if ($item.LinkType -eq "Junction" -and $itemTarget -and (Test-SamePath $itemTarget $Source)) {
            Write-Output "Junction already correct: $Target"
            return
        }

        Backup-Item -Path $Target -Name $BackupName
        Remove-Item -LiteralPath $Target -Recurse -Force
    }

    $parent = Split-Path -Parent $Target
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
    New-Item -ItemType Junction -Path $Target -Target $Source -Force | Out-Null
    Write-Output "Linked $Target"
}

function Install-ConfigFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Source,

        [Parameter(Mandatory = $true)]
        [string]$Target,

        [Parameter(Mandatory = $true)]
        [string]$BackupName
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        Write-Output "Optional config not found: $Source"
        return
    }

    if (Test-Path -LiteralPath $Target) {
        $sourceHash = (Get-FileHash -LiteralPath $Source -Algorithm SHA256).Hash
        $targetHash = (Get-FileHash -LiteralPath $Target -Algorithm SHA256).Hash
        if ($sourceHash -eq $targetHash) {
            Write-Output "Config already current: $Target"
            return
        }
        Backup-Item -Path $Target -Name $BackupName
    }

    $parent = Split-Path -Parent $Target
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
    Copy-Item -LiteralPath $Source -Destination $Target -Force
    Write-Output "Copied $Target"
}

function Install-Scoop {
    $scoop = Join-Path $HOME "scoop\shims\scoop.ps1"
    if (Test-Path -LiteralPath $scoop) {
        return $scoop
    }

    $installer = Join-Path $env:TEMP "scoop-install.ps1"
    Invoke-RestMethod -Uri "https://get.scoop.sh" -OutFile $installer

    $principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $arguments = @("-NoLogo", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $installer)
    if ($isAdmin) {
        $arguments += "-RunAsAdmin"
    }
    Invoke-NativeCommand -FilePath "powershell.exe" -ArgumentList $arguments | Out-Host

    if (-not (Test-Path -LiteralPath $scoop)) {
        throw "Scoop installer did not create $scoop"
    }
    return $scoop
}

function Add-ScoopBucket {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Scoop,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if (Test-Path -LiteralPath (Join-Path $HOME "scoop\buckets\$Name")) {
        return
    }
    Invoke-NativeCommand -FilePath $Scoop -ArgumentList @("bucket", "add", $Name)
}

function Install-ScoopPackage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Scoop,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if (Test-Path -LiteralPath (Join-Path $HOME "scoop\apps\$Name\current")) {
        Write-Output "Package already installed: $Name"
        return
    }

    & $Scoop install $Name
    if ($LASTEXITCODE -ne 0) {
        $script:failedPackages.Add($Name)
        Write-Warning "Package failed: $Name"
    }
}

Write-Output "Windows dotfiles deployment"

if (-not $SkipPackages) {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "winget is required to install PowerShell 7"
    }
    if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
        Invoke-NativeCommand -FilePath "winget" -ArgumentList @(
            "install",
            "--id", "Microsoft.PowerShell",
            "--exact",
            "--source", "winget",
            "--accept-package-agreements",
            "--accept-source-agreements",
            "--disable-interactivity"
        )
    }

    $scoop = Install-Scoop
    $env:PATH = "$(Join-Path $HOME 'scoop\shims');$env:PATH"

    $script:failedPackages = [System.Collections.Generic.List[string]]::new()
    Install-ScoopPackage -Scoop $scoop -Name "git"
    Add-ScoopBucket -Scoop $scoop -Name "extras"
    Add-ScoopBucket -Scoop $scoop -Name "nerd-fonts"

    $packages = @(
        "vim",
        "neovim",
        "neovide",
        "lazygit",
        "gcc",
        "ripgrep",
        "fd",
        "unzip",
        "tree-sitter",
        "luarocks",
        "nodejs-lts",
        "yarn",
        "yazi",
        "lsd",
        "llvm",
        "fzf",
        "sysinternals",
        "zoxide",
        "make",
        "go",
        "ntop",
        "python",
        "gdu",
        "wget",
        "git-aliases",
        "starship",
        "zellij",
        "gitui",
        "uv",
        "vcredist2022",
        "Hack-NF",
        "FiraCode-NF"
    )
    foreach ($package in $packages) {
        Install-ScoopPackage -Scoop $scoop -Name $package
    }

    if ($script:failedPackages.Count -gt 0) {
        throw "Package installation failed: $($script:failedPackages -join ', ')"
    }
} else {
    $env:PATH = "$(Join-Path $HOME 'scoop\shims');$env:PATH"
}

$dotfiles = Join-Path $HOME ".dotfiles"
if ($PSScriptRoot) {
    $repoCandidate = Split-Path -Parent $PSScriptRoot
    $candidateInstaller = Join-Path $repoCandidate "scripts\windows-config-restore.ps1"
    $candidateProfile = Join-Path $repoCandidate "config\windows\pwsh.ps1"
    if ((Test-Path -LiteralPath $candidateInstaller) -and (Test-Path -LiteralPath $candidateProfile)) {
        $dotfiles = $repoCandidate
    }
}
if (-not (Test-Path -LiteralPath $dotfiles)) {
    Invoke-NativeCommand -FilePath "git" -ArgumentList @(
        "clone",
        "--branch", "2026.9",
        "--single-branch",
        "https://github.com/Martins3/My-Linux-Config",
        $dotfiles
    )
}

$legacyZellij = Join-Path $env:APPDATA "zellij"
if (Test-Path -LiteralPath $legacyZellij) {
    $legacyItem = Get-Item -LiteralPath $legacyZellij -Force
    $legacyTarget = $legacyItem.Target | Select-Object -First 1
    $zellijSource = Join-Path $dotfiles "config\zellij"
    if ($legacyItem.LinkType -eq "Junction" -and $legacyTarget -and (Test-SamePath $legacyTarget $zellijSource)) {
        Remove-Item -LiteralPath $legacyZellij -Force
        Write-Output "Removed legacy Zellij junction: $legacyZellij"
    }
}

Install-Junction -Source (Join-Path $dotfiles "nvim") -Target (Join-Path $env:LOCALAPPDATA "nvim") -BackupName "nvim"
Install-Junction -Source (Join-Path $dotfiles "config\gitui") -Target (Join-Path $env:APPDATA "gitui") -BackupName "gitui"
Install-Junction -Source (Join-Path $dotfiles "config\zellij") -Target (Join-Path $env:APPDATA "Zellij\config") -BackupName "zellij"

$configFiles = @(
    @{
        Source = Join-Path $dotfiles ".gitconfig"
        Target = Join-Path $HOME ".gitconfig"
        BackupName = "gitconfig"
    },
    @{
        Source = Join-Path $dotfiles "config\windows\pwsh.ps1"
        Target = Join-Path $HOME "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
        BackupName = "pwsh-profile"
    },
    @{
        Source = Join-Path $dotfiles "config\wezterm.lua"
        Target = Join-Path $HOME ".config\wezterm\wezterm.lua"
        BackupName = "wezterm"
    },
    @{
        Source = Join-Path $dotfiles "config\tigrc.conf"
        Target = Join-Path $HOME ".tigrc"
        BackupName = "tigrc"
    },
    @{
        Source = Join-Path $dotfiles "config\starship.toml"
        Target = Join-Path $HOME ".config\starship.toml"
        BackupName = "starship"
    }
)
foreach ($file in $configFiles) {
    Install-ConfigFile -Source $file.Source -Target $file.Target -BackupName $file.BackupName
}

& (Join-Path $dotfiles "scripts\windows-config-restore.ps1") -BackupRoot $script:backupRoot

if (-not $SkipNeovimSync) {
    Invoke-NativeCommand -FilePath "nvim" -ArgumentList @("--headless", "+Lazy! sync", "+qa")
}

$profilePath = Join-Path $HOME "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
if (-not (Test-Path -LiteralPath $profilePath)) {
    throw "PowerShell profile was not installed"
}
if (-not (Test-Path -LiteralPath (Join-Path $env:LOCALAPPDATA "nvim"))) {
    throw "Neovim config junction was not installed"
}

Write-Output "Deployment complete"
if ($script:backupCreated -or (Test-Path -LiteralPath $script:backupRoot)) {
    Write-Output "Backup: $script:backupRoot"
}
Write-Output "OpenSSH may still start cmd.exe; run pwsh after SSH login if needed."
