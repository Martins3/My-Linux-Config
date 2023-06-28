#!/usr/bin/env bash

set -x
sudo nix-channel --add https://nixos.org/channels/nixos-23.05 nixos
sudo nix-channel --add https://nixos.org/channels/nixos-23.05 nixpkgs
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable/ unstable
sudo nix-channel --add https://nixos.org/channels/nixos-unstable/ nixos-unstable
sudo nix-channel --update
