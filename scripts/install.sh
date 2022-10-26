#!/usr/bin/env bash
cd ~ || exit 0
if [[ ! -d ~/.dotfiles ]]; then
  git clone https://github.com/Martins3/My-Linux-config .dotfiles
fi
mkdir -p ~/.config
mkdir -p ~/.carfig/wtf
mkdir -p ~/.cargo

ln -sf ~/.dotfiles/nixpkgs ~/.config/nixpkgs
ln -sf ~/.dotfiles/nvim ~/.config/nvim
ln -sf ~/.dotfiles/config/tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/config/tigrc.conf ~/.tigrc
ln -sf ~/.dotfiles/config/kitty ~/.config/kitty
ln -sf ~/.dotfiles/config/wtf.yml ~/.config/wtf/config.yml
ln -sf ~/.dotfiles/config/zathurarc ~/.config/zathura/zathurarc
ln -sf ~/.dotfiles/config/starship.toml ~/.config/starship.toml
ln -sf ~/.dotfiles/config/cargo.conf ~/.cargo/config

echo "tmux plugin install : prefix + I"
# kitty is used to substitute alacritty
# ln -sf ~/.dotfiles/conf/alacritty.yml ~/.alacritty.yml
