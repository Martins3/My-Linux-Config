#!/usr/bin/env bash

set -E -e -u -o pipefail

while getopts "b" opt; do
	case $opt in
		b)
			systemctl --user start qemu
			exit 0
			;;

		*)
			exit 1
			;;
	esac
done

/home/martins3/.dotfiles/scripts/systemd/sync-qemu.sh
