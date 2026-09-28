param(
    [string]$Solution = (Join-Path $HOME "data\Windows-driver-samples\general\echo\kmdf\kmdfecho.sln"),

    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Debug",

    [ValidateSet("x64", "ARM64")]
    [string]$Platform = "x64",

    [ValidateSet("Build", "Rebuild", "Clean")]
    [string]$Target = "Rebuild"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $Solution)) {
    throw "Solution was not found: $Solution"
}

$vswhere = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio\Installer\vswhere.exe"
if (-not (Test-Path -LiteralPath $vswhere)) {
    throw "vswhere was not found; install Visual Studio and WDK first"
}

$visualStudio = & $vswhere `
    -latest `
    -products "*" `
    -requires Microsoft.Component.MSBuild Component.Microsoft.Windows.DriverKit `
    -property installationPath
if (-not $visualStudio) {
    throw "Visual Studio is missing MSBuild or the Windows Driver Kit component"
}

# WDK 28000 no longer has a complete x86 kernel-driver verification toolchain.
# Always use 64-bit MSBuild, even when the target platform is x64 rather than ARM64.
$msbuild = Join-Path $visualStudio "MSBuild\Current\Bin\amd64\MSBuild.exe"
if (-not (Test-Path -LiteralPath $msbuild)) {
    throw "64-bit MSBuild was not found: $msbuild"
}

Write-Output "MSBuild: $msbuild"
Write-Output "Solution: $Solution"
Write-Output "Configuration: $Configuration; Platform: $Platform; Target: $Target"

& $msbuild `
    $Solution `
    "/m" `
    "/t:$Target" `
    "/p:Configuration=$Configuration" `
    "/p:Platform=$Platform" `
    "/v:minimal"
if ($LASTEXITCODE -ne 0) {
    throw "Driver build failed with exit code $LASTEXITCODE"
}

Write-Output "Driver build completed"
