#!/usr/bin/env bash
set -E -e -u -o pipefail
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

[[ ! -d ~/.config/nvim ]] && ln -sf ~/.dotfiles/nvim ~/.config/nvim
[[ ! -d ~/.config/kitty ]] && ln -sf ~/.dotfiles/config/kitty ~/.config/kitty
[[ ! -d ~/.config/zellij ]] && ln -sf ~/.dotfiles/config/zellij ~/.config/zellij

ln -sf ~/.dotfiles/config/tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/config/tigrc.conf ~/.tigrc
ln -sf ~/.dotfiles/config/alacritty.yml ~/.alacritty.yml
ln -sf ~/.dotfiles/config/wtf.yml ~/.config/wtf/config.yml
ln -sf ~/.dotfiles/config/zathurarc ~/.config/zathura/zathurarc
ln -sf ~/.dotfiles/config/starship.toml ~/.config/starship.toml
ln -sf ~/.dotfiles/config/cargo.conf ~/.cargo/config
ln -sf ~/.dotfiles/config/wezterm.lua ~/.config/wezterm/wezterm.lua
ln -sf ~/.dotfiles/config/atuin.toml ~/.config/atuin/config.toml

# dhruvmanila/browser-bookmarks.nvim
ln -sf ~/.config/google-chrome-stable ~/.config/microsoft-edge

mkdir -p ~/.config/efm-langserver/
ln -sf ~/.dotfiles/nvim/efm.yaml ~/.config/efm-langserver/config.yaml

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	echo "tmux plugin install : prefix + I"
fi
