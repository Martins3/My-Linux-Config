#!/usr/bin/env bash
set -E -e -u -o pipefail

dotfiles="$HOME/.dotfiles"

if [[ ! -d $dotfiles ]]; then
	git clone https://github.com/Martins3/My-Linux-config "$dotfiles"
fi

mkdir -p "$HOME/.cargo" "$HOME/.config"/{atuin,efm-langserver,pueue,wezterm,wtf,zathura}

[[ -d "$HOME/.config/nvim" ]] || ln -sf "$dotfiles/nvim" "$HOME/.config/nvim"
for name in ghostty gitui htop kitty zellij; do
	[[ -d "$HOME/.config/$name" ]] || ln -sf "$dotfiles/config/$name" "$HOME/.config/$name"
done

declare -A links=(
	["config/tmux.conf"]=".tmux.conf"
	["config/tigrc.conf"]=".tigrc"
	["config/alacritty.toml"]=".alacritty.toml"
	["config/wtf.yml"]=".config/wtf/config.yml"
	["config/zathurarc"]=".config/zathura/zathurarc"
	["config/starship.toml"]=".config/starship.toml"
	["config/cargo.toml"]=".cargo/config.toml"
	["config/wezterm.lua"]=".config/wezterm/wezterm.lua"
	["config/atuin.toml"]=".config/atuin/config.toml"
	["config/pueue.yml"]=".config/pueue/pueue.yml"
	["nvim/efm.yaml"]=".config/efm-langserver/config.yaml"
)

for source_path in "${!links[@]}"; do
	ln -sf "$dotfiles/$source_path" "$HOME/${links[$source_path]}"
done

if [[ ! -L "$HOME/.gitconfig" ]]; then
	ln -sf "$dotfiles/config/gitconfig" "$HOME/.gitconfig"
fi

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
	git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
	echo "tmux plugin install : prefix + I"
fi

if systemctl is-active --quiet graphical.target; then
	bash "$dotfiles/rime/linux-install.sh"
	echo "Almost finished，open fcitx 5 Configiration"
fi
