#!/usr/bin/env bash

set -E -e -u -o pipefail
# shopt -s inherit_errexit
# PROGNAME=$(basename "$0")
# PROGDIR=$(readlink -m "$(dirname "$0")")
for i in "$@"; do
	echo "$i"
done
cd "$(dirname "$0")"

cd ~/core
if [[ ! -d crash ]]; then
	git clone https://github.com/crash-utility/crash
fi
cd crash
ln -sf /home/martins3/.dotfiles/scripts/nix/env/crash.nix default.nix
# nix-shell --command "./configure -x lzo"
nix-shell --command "make -j32"
# 完全理解之后提交给 nixos 社区吧？
