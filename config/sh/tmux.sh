#!/usr/bin/env bash

set -E -e -u -o pipefail

tmuxp load -d ~/.dotfiles/config/tmux-note.yaml
tmuxp load -d ~/.dotfiles/config/tmux-code.yaml

if [[ -n $TMUX ]]; then
	# 如果在 tmux 中，先退出
	exit 0
else
  # 
	exit 1
fi
