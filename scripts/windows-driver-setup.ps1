param(
    [string]$SamplesRoot = (Join-Path $HOME "data\Windows-driver-samples"),
    [switch]$SkipSamples
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

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget is required"
}

$configurationUri = "https://raw.githubusercontent.com/microsoft/Windows-driver-samples/main/_wdk_utils/winget/configs/wdk-vscommunity.dsc.yaml"

& winget configure show -f $configurationUri --disable-interactivity | Out-Host
if ($LASTEXITCODE -eq 105) {
    Invoke-NativeCommand -FilePath "winget" -ArgumentList @("configure", "--enable")
    Invoke-NativeCommand -FilePath "winget" -ArgumentList @(
        "configure", "show", "-f", $configurationUri, "--disable-interactivity"
    )
} elseif ($LASTEXITCODE -ne 0) {
    throw "Unable to inspect the official WDK WinGet configuration: $LASTEXITCODE"
}

Invoke-NativeCommand -FilePath "winget" -ArgumentList @(
    "configure",
    "-f", $configurationUri,
    "--accept-configuration-agreements",
    "--disable-interactivity"
)

& winget list --id Microsoft.WinDbg --exact --disable-interactivity | Out-Host
if ($LASTEXITCODE -eq 0) {
    Write-Output "WinDbg is already installed"
} else {
    Invoke-NativeCommand -FilePath "winget" -ArgumentList @(
        "install",
        "--id", "Microsoft.WinDbg",
        "--exact",
        "--accept-package-agreements",
        "--accept-source-agreements",
        "--disable-interactivity"
    )
}

if (-not $SkipSamples) {
    if (Test-Path -LiteralPath $SamplesRoot) {
        Write-Output "Windows driver samples already exist: $SamplesRoot"
    } else {
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $SamplesRoot) | Out-Null
        Invoke-NativeCommand -FilePath "git" -ArgumentList @(
            "clone", "--depth", "1",
            "https://github.com/microsoft/Windows-driver-samples.git",
            $SamplesRoot
        )
    }
}

$vswhere = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio\Installer\vswhere.exe"
if (-not (Test-Path -LiteralPath $vswhere)) {
    throw "Visual Studio installation was not found"
}

$visualStudio = & $vswhere `
    -latest `
    -products "*" `
    -requires Microsoft.Component.MSBuild Component.Microsoft.Windows.DriverKit `
    -property installationPath
if (-not $visualStudio) {
    throw "Visual Studio is missing MSBuild or the Windows Driver Kit component"
}

$msbuild = Join-Path $visualStudio "MSBuild\Current\Bin\amd64\MSBuild.exe"
if (-not (Test-Path -LiteralPath $msbuild)) {
    throw "64-bit MSBuild was not found: $msbuild"
}

$wdkTargets = Get-ChildItem `
    (Join-Path ${env:ProgramFiles(x86)} "Windows Kits\10\build") `
    -Filter "WindowsDriver.Common.targets" `
    -Recurse `
    -ErrorAction SilentlyContinue |
    Sort-Object FullName -Descending |
    Select-Object -First 1
if (-not $wdkTargets) {
    throw "WDK MSBuild targets were not found"
}

Write-Output "Driver development environment is ready"
Write-Output "Visual Studio: $visualStudio"
Write-Output "MSBuild: $msbuild"
Write-Output "WDK targets: $($wdkTargets.FullName)"
if (-not $SkipSamples) {
    Write-Output "Samples: $SamplesRoot"
}
