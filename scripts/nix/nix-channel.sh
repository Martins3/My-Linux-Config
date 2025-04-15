#!/usr/bin/env bash

set -x
if [[ -f /etc/nixos/configuration.nix ]]; then
	SUDO=sudo
else
  SUDO=""
fi
$SUDO nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager

# $SUDO nix-channel --add https://nixos.org/channels/nixos-24.05 nixos
# $SUDO nix-channel --add https://nixos.org/channels/nixos-24.05 nixpkgs
# $SUDO nix-channel --add https://nixos.org/channels/nixpkgs-unstable/ unstable
# $SUDO nix-channel --add https://nixos.org/channels/nixos-unstable/ nixos-unstable

if [[ -f /etc/nixos/configuration.nix ]]; then
	$SUDO nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-24.11 nixos
	$SUDO nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-unstable/ nixos-unstable
fi
$SUDO nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-24.11 nixpkgs
$SUDO nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable unstable

$SUDO nix-channel --update
