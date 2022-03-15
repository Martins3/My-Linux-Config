#!/bin/bash
set -x
shopt -s extglob nullglob
for i in rime/*.@(yaml|txt);do
  ln -sf "$(pwd)/$i" ~/.config/fcitx/"$i"
done

