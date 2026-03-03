# Windows 配置恢复脚本
# 从 dotfiles 恢复 Windows Terminal、VS Code、PowerToys 配置

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$backupDir = Join-Path $repoRoot "config/windows"

Write-Host "=== Windows 配置恢复工具 ===" -ForegroundColor Cyan
Write-Host "恢复来源: $backupDir" -ForegroundColor Gray
Write-Host ""

# 检查备份目录
if (-not (Test-Path $backupDir)) {
    Write-Host "错误: 备份目录不存在!" -ForegroundColor Red
    exit 1
}

# Windows Terminal
$wtDest = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
Write-Host "[1/3] Windows Terminal..." -ForegroundColor Yellow
if (Test-Path "$backupDir/terminal.json") {
    if (-not (Test-Path $wtDest)) {
        New-Item -ItemType Directory -Force -Path $wtDest | Out-Null
    }
    Copy-Item "$backupDir/terminal.json" "$wtDest/settings.json" -Force
    Write-Host "    ✓ 已恢复 terminal.json" -ForegroundColor Green
} else {
    Write-Host "    ✗ 未找到备份文件" -ForegroundColor Red
}

Write-Host ""
Write-Host "恢复完成！请重新启动相关应用程序。" -ForegroundColor Cyan
