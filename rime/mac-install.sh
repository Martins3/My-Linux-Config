#!/usr/bin/env bash

set -ex
CONFIG_DIR=~/Library/Rime # maos



if [[ $0 != "./mac-install.sh" ]]; then
  echo "run the program in .dotfiles/rime"
  exit 1
fi

shopt -s extglob nullglob

for i in *.@(yaml|txt);do
  ln -sf "$(pwd)/$i" "$CONFIG_DIR/$i"
done
