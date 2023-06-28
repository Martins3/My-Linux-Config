#!/usr/bin/env bash

set -E -e -u -o pipefail

ln -sf /home/martins3/.dotfiles/config/ /home/martins3/.config/home-manager
mkdir -p /home/martins3/.config/nix/
ln -sf /home/martins3/.dotfiles/config/nix.conf /home/martins3/.config/nix/nix.conf
line="/home/martins3/.config/home-manager/system.nix"
sudo sed -i "/hardware-configuration.nix/a $line" /etc/nixos/configuration.nix
sudo ./nix/nix-channel.sh
sudo nixos-rebuild switch
nix-shell '<home-manager>' -A install
home-manager switch
