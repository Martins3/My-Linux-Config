#!/usr/bin/env bash

set -E -e -u -o pipefail

# TODO 扩展为选项吧
function change_wez() {
	local file=$HOME/.dotfiles/config/wezterm.lua

	if grep window_background_opacity "$file" | grep -o "1.0"; then
		sed -i "s/window_background_opacity = 1.0/window_background_opacity = 0.9/" "$file"
	else
		sed -i "s/window_background_opacity = 0.9/window_background_opacity = 1.0/" "$file"
	fi
}

function change_kitty() {
	local file=config/kitty/kitty.conf
}
