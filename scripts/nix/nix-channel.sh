#!/usr/bin/env bash

set -x
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager

# sudo nix-channel --add https://nixos.org/channels/nixos-24.05 nixos
# sudo nix-channel --add https://nixos.org/channels/nixos-24.05 nixpkgs
# sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable/ unstable
# sudo nix-channel --add https://nixos.org/channels/nixos-unstable/ nixos-unstable

sudo nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-24.05 nixos
sudo nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-24.05 nixpkgs
sudo nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable unstable
sudo nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-unstable/ nixos-unstable

sudo nix-channel --update
