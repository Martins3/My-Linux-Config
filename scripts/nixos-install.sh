#!/usr/bin/env bash

set -E -e -u -o pipefail
# shopt -s inherit_errexit
# PROGNAME=$(basename "$0")
# PROGDIR=$(readlink -m "$(dirname "$0")")
for i in "$@"; do
  echo "$i"
done
cd "$(dirname "$0")"

./install.sh
line="/home/martins3/.config/nixpkgs/system.nix"
sed "/hardware-configuration.nix/a $line" /etc/nixos/configuration.nix
sudo ./nix/nix-channel.sh
nixos-rebuild switch
nix-shell '<home-manager>' -A install
home-manager switch
