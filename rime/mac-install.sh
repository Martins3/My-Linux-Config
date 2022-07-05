#!/usr/bin/env bash

set -x
CONFIG_DIR=~/.config/fcitx # fcitx4
CONFIG_DIR=~/Library/Rime # maos

shopt -s extglob nullglob
echo "Notice : run the program in ~/.dotfiles/rime"

for i in *.@(yaml|txt);do
  ln -sf "$(pwd)/$i" "$CONFIG_DIR/$i"
done



