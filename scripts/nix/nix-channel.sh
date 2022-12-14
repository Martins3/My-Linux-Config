#!/usr/bin/env bash

sudo nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-22.11 nixos # 对于 NixOS
sudo nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-22.11 nixpkgs # 对于 Nix
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz home-manager
sudo nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable unstable
sudo nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-unstable/ nixos-unstable
sudo nix-channel --update
