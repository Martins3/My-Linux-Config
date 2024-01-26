#!/usr/bin/env bash

set -E -e -u -o pipefail

mkdir -p /home/martins3/.config
ln -sf /home/martins3/.dotfiles/nixpkgs /home/martins3/.config/home-manager
mkdir -p /home/martins3/.config/nix/
ln -sf /home/martins3/.dotfiles/config/nix.conf /home/martins3/.config/nix/nix.conf
line="/home/martins3/.config/home-manager/system.nix"
sudo sed -i "/hardware-configuration.nix/a $line" /etc/nixos/configuration.nix
sudo /home/martins3/.dotfiles/scripts/nix/nix-channel.sh
sudo nixos-rebuild switch
nix-shell '<home-manager>' -A install
home-manager switch
