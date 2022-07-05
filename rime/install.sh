#!/usr/bin/env bash

set -x
CONFIG_DIR=~/.config/fcitx # fcitx4
CONFIG_DIR=~/Library/Rime # maos

# TMP_TODO : so wired, man !
shopt -s extglob nullglob
echo "Notice : run the program in ~/.dotfiles"

for i in rime/*.@(yaml|txt);do
  ln -sf "$(pwd)/$i" "$CONFIG_DIR/$i"
done
