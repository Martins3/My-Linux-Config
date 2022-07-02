#!/usr/bin/env bash

set -x
shopt -s extglob nullglob
echo "Notice : run the program in ~/.dotfiles"
for i in rime/*.@(yaml|txt);do
  ln -sf "$(pwd)/$i" ~/.config/fcitx/"$i"
done
