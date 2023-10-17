#!/usr/bin/env bash
set -E -e -u -o pipefail

normal=~/.dotfiles/nvim/
debug=~/.dotfiles/nvim/debug
target=~/.config/nvim
if ! cur=$(readlink $target); then
	ln -sf $normal $target
	echo "switch to normal mode"
	exit 0
fi

if [[ $cur != "$normal" ]]; then
	rm -f $target
	ln -sf $normal $target
	echo "switch to normal mode"
else
	rm -f $target
	ln -sf $debug $target
	echo "switch to debug mode"
fi
