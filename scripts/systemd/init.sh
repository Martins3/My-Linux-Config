#!/usr/bin/env bash

set -E -e -u -o pipefail
for i in "$@"; do
  echo "$i"
done
cd "$(dirname "$0")"

version="$1"
# @todo 判断一下，这个必须是 number

function defconfig() {
  # cp /home/martins3/.dotfiles/scripts/systemd/martins3.config kernel/configs/martins3.config
  make defconfig kvm_guest.config martins3.config

  if [[ -n ${version+x} ]]; then
    sed -i "s/CONFIG_LOCALVERSION=\"\"/CONFIG_LOCALVERSION=\"$version\"/g" .config
  fi
}

defconfig
