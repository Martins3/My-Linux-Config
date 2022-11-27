#!/usr/bin/env bash

set -x
CONFIG_DIR=~/.config/fcitx5 # fcitx4

shopt -s extglob nullglob
echo "Notice : run the program in ~/.dotfiles"

for i in rime/*.@(yaml|txt);do
  ln -sf "$(pwd)/$i" "$CONFIG_DIR/$i"
done
