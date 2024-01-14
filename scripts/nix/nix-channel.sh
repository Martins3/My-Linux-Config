#!/usr/bin/env bash

set -x
sudo nix-channel --add https://nixos.org/channels/nixos-23.11 nixos
sudo nix-channel --add https://nixos.org/channels/nixos-23.11 nixpkgs
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable/ unstable
sudo nix-channel --add https://nixos.org/channels/nixos-unstable/ nixos-unstable

sudo nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-23.11 nixos
sudo nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-23.11 nixpkgs
sudo nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable unstable
sudo nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-unstable/ nixos-unstable

sudo nix-channel --update

