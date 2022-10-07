#!/usr/bin/env bash
cd ~ || exit 0
git clone https://github.com/Martins3/My-Linux-config .dotfiles
ln -sf ~/.dotfiles/conf/tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/conf/tigrc.conf ~/.tigrc
ln -sf ~/.dotfiles/conf/kitty ~/.config/kitty
ln -sf ~/.dotfiles/nvim ~/.config/nvim
ln -sf ~/.dotfiles/conf/wtf.yml ~/.config/wtf/config.yml
ln -sf ~/.dotfiles/conf/zathurarc ~/.config/zathura/zathurarc

# kitty is used to substitute alacritty
# ln -sf ~/.dotfiles/conf/alacritty.yml ~/.alacritty.yml
