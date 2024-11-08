#!/usr/bin/env bash

set -E -e -u -o pipefail
function usage() {
	echo "Usage :   [options] [--]

    Options:
    -h|help       Display this message
    -n|note       Only open note session
    -c|code       Only open code session
    "
}

function note() {
	tmuxp load -d ~/.dotfiles/config/tmux-note.yaml
}

function code() {
	tmuxp load -d ~/.dotfiles/config/tmux-code.yaml
}

while getopts "cn" opt; do
	case $opt in
		c)
			code
			exit 0
			;;
		n)
			note
			exit 0
			;;
		*)
			echo -e "\n  Option does not exist : OPTARG\n"
			usage
			;;
	esac
done

code
note
