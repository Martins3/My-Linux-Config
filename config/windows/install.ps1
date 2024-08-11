Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression


scoop install git vim neovim
scoop bucket add nerd-fonts
scoop install Hack-NF
