#!/usr/bin/env bash
cd ~ || exit 0
if [[ ! -d ~/.dotfiles ]]; then
  git clone https://github.com/Martins3/My-Linux-config .dotfiles
fi
mkdir -p ~/.config
mkdir -p ~/.config/wtf
mkdir -p ~/.config/zathura
mkdir -p ~/.cargo

ln -sf ~/.dotfiles/nixpkgs ~/.config/nixpkgs
ln -sf ~/.dotfiles/nvim ~/.config/nvim
ln -sf ~/.dotfiles/config/tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/config/tigrc.conf ~/.tigrc
ln -sf ~/.dotfiles/config/kitty ~/.config/kitty
ln -sf ~/.dotfiles/config/alacritty.yml ~/.alacritty.yml
ln -sf ~/.dotfiles/config/wtf.yml ~/.config/wtf/config.yml
ln -sf ~/.dotfiles/config/zathurarc ~/.config/zathura/zathurarc
ln -sf ~/.dotfiles/config/starship.toml ~/.config/starship.toml
ln -sf ~/.dotfiles/config/cargo.conf ~/.cargo/config

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "tmux plugin install : prefix + I"
fi

