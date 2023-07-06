#!/usr/bin/env bash

set -E -e -u -o pipefail
for i in "$@"; do
  echo "$i"
done
cd "$(dirname "$0")"

function defconfig() {
  make defconfig kvm_guest.config martins3.config
  # 好像这个没啥用
  # sed -i "s/CONFIG_LOCALVERSION=\"\"/CONFIG_LOCALVERSION=\"$version\"/g" .config
}

defconfig
make binrpm-pkg -j32
