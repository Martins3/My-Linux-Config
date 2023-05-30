#!/usr/bin/env bash

set -E -e -u -o pipefail

while getopts "bch" opt; do
	case $opt in
		b)
			systemctl --user start kernel
			exit 0
			;;
		c)
			export ENABLE_KCOV=true
			;;
		h)
			echo "-b : started by systemd"
			echo "-c : with kcov option"
			exit 0
			;;
		*)
			exit 1
			;;
	esac
done

/home/martins3/.dotfiles/scripts/systemd/sync-kernel.sh
