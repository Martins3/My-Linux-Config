#!/usr/bin/env bash

set -E -e -u -o pipefail
# shopt -s inherit_errexit
# PROGNAME=$(basename "$0")
# PROGDIR=$(readlink -m "$(dirname "$0")")
for i in "$@"; do
  echo "$i"
done
cd "$(dirname "$0")"

ln -sf /home/martins3/.dotfiles/config/ /home/martins3/.config/home-manager
ln -sf /home/martins3/.dotfiles/config/nix.conf /home/martins3/.config/nix/nix.conf
line="/home/martins3/.config/home-manager/system.nix"
sudo sed -i "/hardware-configuration.nix/a $line" /etc/nixos/configuration.nix
sudo ./nix/nix-channel.sh
sudo nixos-rebuild switch
nix-shell '<home-manager>' -A install
home-manager switch
