#!/usr/bin/env bash

set -E -e -u -o pipefail

if [[ ! -d "$HOME"/.config/nixpkgs ]]; then
	mkdir -p "$HOME"/.config/nixpkgs
	mkdir -p "$HOME"/.config/nix/
	ln -sf "$HOME"/.dotfiles/nixpkgs "$HOME"/.config/home-manager
	ln -sf "$HOME"/.dotfiles/nixpkgs/config.nix "$HOME"/.config/nixpkgs/config.nix
	ln -sf "$HOME"/.dotfiles/config/nix.conf "$HOME"/.config/nix/nix.conf
fi

if [[ -f /etc/nixos/configuration.nix ]]; then
	line="(import $HOME/.config/home-manager/system.nix { disable_gui = 0; })"
	sudo sed -i "/hardware-configuration.nix/a $line" /etc/nixos/configuration.nix
	# shellcheck disable=SC2016
	hash='$6$Iehu.x9i7eiceV.q$X4INuNrrxGvdK546sxdt3IV9yHr90/Mxo7wuIzdowoN..jFSFjX8gHaXchfBxV4pOYM4h38pPJOeuI1X/5fon/'
	line="users.users.root.hashedPassword = \"$hash\";"
	echo "$line" >>/etc/nixos/configuration.nix
	line="users.users.martins3.hashedPassword = \"$hash\";"
	echo "$line" >>/etc/nixos/configuration.nix

	sudo "$HOME"/.dotfiles/scripts/nix/nix-channel.sh
	sudo nixos-rebuild switch
else
	# 和 nixpkgs/opt.nix 对应，用于仅仅安装 home-manager
	cat <<_EOF >"$HOME"/opt-local.nix
{
  isGui = false;
}
_EOF
fi

nix-shell '<home-manager>' -A install
home-manager switch
