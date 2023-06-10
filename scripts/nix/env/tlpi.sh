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
if [[ -d tlpi-dist ]]; then
  echo "already setup"
	exit 0
fi

wget https://man7.org/tlpi/code/download/tlpi-220912-dist.tar.gz
tar -xvf tlpi-220912-dist.tar.gz
rm tlpi-220912-dist.tar.gz
cd tlpi-dist
git init
git add -A

ln /home/martins3/.dotfiles/scripts/nix/env/tlpi.nix default.nix
echo "use nix" >> .envrc && direnv allow

# 存在如下的报错:
# 据说 lcrypt 是在 glibc 中，但是实际上并没有作用
# gcc -std=c99 -D_XOPEN_SOURCE=600 -D_DEFAULT_SOURCE -g -I../lib -pedantic -Wall -W -Wmissing-prototypes -Wno-sign-compare -Wimplicit-fallthrough -Wno-unused-parameter    cap_launcher.c ../libtlpi.a  ../libtlpi.a -lcap -lcrypt -o cap_launcher
# /nix/store/22p5nv7fbxhm06mfkwwnibv1nsz06x4b-binutils-2.40/bin/ld: cannot find -lcrypt: No such file or directory
# collect2: error: ld returned 1 exit status
# make[1]: *** [<builtin>: cap_launcher] Error 1
# make[1]: Leaving directory '/home/martins3/core/tlpi-dist/cap'
cd lib && make
