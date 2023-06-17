#!/usr/bin/env bash

set -E -e -u -o pipefail

if grep "GenuineIntel" /proc/cpuinfo >/dev/null; then
	tmuxp load -d ~/.dotfiles/config/tmux-session.yaml
elif grep "AuthenticAMD" /proc/cpuinfo >/dev/null; then
	tmuxp load -d ~/.dotfiles/config/tmux-session2.yaml
else
	echo "not implement Yet"
fi
