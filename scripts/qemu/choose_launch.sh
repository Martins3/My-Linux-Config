#!/usr/bin/env bash
set -E -e -u -o pipefail

choose=$(/home/martins3/.dotfiles/scripts/qemu/choose.sh inactive)
if [[ -z $choose ]]; then
  echo "No vm choosed 😸"
  exit 0
fi
rm -f ~/hack/martins3
ln -s "$choose" ~/hack/martins3
/home/martins3/core/vn/docs/qemu/sh/alpine.sh "$*"
