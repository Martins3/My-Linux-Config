#!/usr/bin/env bash

set -E -e -u -o pipefail

mkdir -p /home/martins3/.config/nixpkgs
ln -sf /home/martins3/.dotfiles/nixpkgs /home/martins3/.config/home-manager
ln -sf /home/martins3/.dotfiles/nixpkgs/config.nix /home/martins3/.config/nixpkgs/config.nix
mkdir -p /home/martins3/.config/nix/
ln -sf /home/martins3/.dotfiles/config/nix.conf /home/martins3/.config/nix/nix.conf

line="(import /home/martins3/.config/home-manager/system.nix { disable_gui = 0; })"
sudo sed -i "/hardware-configuration.nix/a $line" /etc/nixos/configuration.nix
# shellcheck disable=SC2016
hash='$6$Iehu.x9i7eiceV.q$X4INuNrrxGvdK546sxdt3IV9yHr90/Mxo7wuIzdowoN..jFSFjX8gHaXchfBxV4pOYM4h38pPJOeuI1X/5fon/'
line="users.users.root.hashedPassword = \"$hash\";"
echo "$line" >> /etc/nixos/configuration.nix
line="users.users.martins3.hashedPassword = \"$hash\";"
echo "$line" >> /etc/nixos/configuration.nix

sudo /home/martins3/.dotfiles/scripts/nix/nix-channel.sh

sudo nixos-rebuild switch

nix-shell '<home-manager>' -A install
home-manager switch
