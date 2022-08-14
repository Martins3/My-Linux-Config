#!/usr/bin/env bash

sudo nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-22.05 nixos # 对于NixOS
sudo nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-22.05 nixpkgs # 对于Nix
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz home-manager
sudo nix-channel --add https://nixos.org/channels/nixos-unstable unstable
sudo nix-channel --update
