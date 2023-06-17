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

function code() {
	if grep "GenuineIntel" /proc/cpuinfo >/dev/null; then
		tmuxp load -d ~/.dotfiles/config/tmux-session.yaml
	elif grep "AuthenticAMD" /proc/cpuinfo >/dev/null; then
		tmuxp load -d ~/.dotfiles/config/tmux-session2.yaml
	else
		echo "not implement Yet"
	fi
}

function note() {
	tmuxp load -d ~/.dotfiles/config/tmux-session3.yaml
}

while getopts "hcn" opt; do
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
			exit 1
			;;
	esac
done

code
note
