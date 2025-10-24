# 同步
ls "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

cp "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "$HOME\.dotfiles\config\windows\terminal.json"

# VisualStudio 的配置应该是通过 Github 账号登录就可以自动同步了
