#!/usr/bin/env bash

set -E -e -u -o pipefail
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
echo "use nix" >>.envrc && direnv allow

cat << _EOF_ > .gitignore
.ccls-cache
.direnv
_EOF_

cd lib && make
