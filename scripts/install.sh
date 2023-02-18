#!/usr/bin/env bash
cd ~ || exit 0
if [[ ! -d ~/.dotfiles ]]; then
  git clone https://github.com/Martins3/My-Linux-config .dotfiles
fi
mkdir -p ~/.config
mkdir -p ~/.config/wtf
mkdir -p ~/.config/wezterm
mkdir -p ~/.config/zathura
mkdir -p ~/.cargo
mkdir -p ~/.config/atuin/
mkdir -p ~/.telegraf

ln -sf ~/.dotfiles/config/telegraf.conf ~/.telegraf/telegraf.conf
ln -sf ~/.dotfiles/config/nushell ~/.config/nushell
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
ln -sf ~/.dotfiles/config/wezterm.lua ~/.config/wezterm/wezterm.lua
ln -sf ~/.dotfiles/config/zellij ~/.config/zellij
ln -sf ~/.dotfiles/config/atuin.toml ~/.config/atuin/config.toml

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "tmux plugin install : prefix + I"
fi
