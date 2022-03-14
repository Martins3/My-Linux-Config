#!/bin/bash
set -x
for i in rime/*.yaml;do
  ln -sf "$(pwd)/$i" ~/.config/fcitx/"$i"
done
