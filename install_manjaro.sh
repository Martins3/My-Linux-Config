#!/bin/bash
exit 0

# change software source
# multiprocess is too difficult for me !
sudo pacman-mirrors -i -c China -m rank
sudo pacman -Syy
pacman -S archlinux-keyring 

# install all kinds of runtime software

# vim
git clone git@github.com:XiongGuiHui/My-Linux-config.git ~/.SpaceVim.d
curl -sLf https://spacevim.org/cn/install.sh | bash

# zsh
rm ~/.zshrc
ln ~/

# gtags
sudo pacman -S ctags python-pygments
