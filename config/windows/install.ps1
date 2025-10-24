# 安装 scoop
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

scoop install git vim neovim
scoop bucket add nerd-fonts
scoop install Hack-NF

scoop install neovim neovide git lazygit gcc ripgrep fd unzip tree-sitter luarocks yarn yazi lsd llvm fzf
scoop install Sysinternals zoxide make go ripgrep
scoop install ntop python gdu
scoop install ntop python wget
# scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json
