# Windows 配置备份脚本
# 将 Windows Terminal、VS Code、PowerToys 配置备份到 dotfiles

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$backupDir = Join-Path $repoRoot "config/windows"

Write-Host "=== Windows 配置备份工具 ===" -ForegroundColor Cyan
Write-Host "备份目录: $backupDir" -ForegroundColor Gray
Write-Host ""

# Windows Terminal
$wtSource = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Write-Host "[1/3] Windows Terminal..." -ForegroundColor Yellow
if (Test-Path $wtSource) {
    Copy-Item $wtSource "$backupDir/terminal.json" -Force
    Write-Host "    ✓ 已备份 terminal.json" -ForegroundColor Green
} else {
    Write-Host "    ✗ 未找到 Windows Terminal 配置" -ForegroundColor Red
}

# VisualStudio 的配置应该是通过 Github 账号登录就可以自动同步了

# PowerToys
# TODO

Write-Host "备份完成！请检查 git status 并提交更改。" -ForegroundColor Cyan
