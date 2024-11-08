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
mkdir -p ~/.config/pueue

[[ ! -d ~/.config/nvim ]] && ln -sf ~/.dotfiles/nvim ~/.config/nvim
[[ ! -d ~/.config/kitty ]] && ln -sf ~/.dotfiles/config/kitty ~/.config/kitty
[[ ! -d ~/.config/zellij ]] && ln -sf ~/.dotfiles/config/zellij ~/.config/zellij
[[ ! -d ~/.config/gitui ]] && ln -sf ~/.dotfiles/config/gitui ~/.config/gitui

ln -sf ~/.dotfiles/config/tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/config/tigrc.conf ~/.tigrc
ln -sf ~/.dotfiles/config/alacritty.toml ~/.alacritty.toml
ln -sf ~/.dotfiles/config/wtf.yml ~/.config/wtf/config.yml
ln -sf ~/.dotfiles/config/zathurarc ~/.config/zathura/zathurarc
ln -sf ~/.dotfiles/config/starship.toml ~/.config/starship.toml
ln -sf ~/.dotfiles/config/cargo.toml ~/.cargo/config.toml
ln -sf ~/.dotfiles/config/wezterm.lua ~/.config/wezterm/wezterm.lua
ln -sf ~/.dotfiles/config/atuin.toml ~/.config/atuin/config.toml
ln -sf ~/.dotfiles/config/pueue.yml ~/.config/pueue/pueue.yml

if [[ ! -L ~/.gitconfig ]]; then
	ln -sf ~/.dotfiles/config/gitconfig ~/.gitconfig
fi

mkdir -p ~/.config/efm-langserver/
ln -sf ~/.dotfiles/nvim/efm.yaml ~/.config/efm-langserver/config.yaml

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	echo "tmux plugin install : prefix + I"
  # TODO 真的服了，各种问题
  # 1. catppuccin/tmux 这个项目 api 变化太快
  # 2. 下载之后自动 checkout
  # cd .tmux/plugins/tmux && git checkout 7a284c98e5df4cc84a1a45ad633916
fi

if systemctl list-units --type target | grep graphical; then
	bash "$HOME"/.dotfiles/rime/linux-install.sh
	echo "Almost finished，open fcitx 5 Configiration"
fi
