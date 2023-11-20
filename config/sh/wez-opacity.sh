#!/usr/bin/env bash

set -E -e -u -o pipefail
file=/home/martins3/.dotfiles/config/wezterm.lua

if grep window_background_opacity $file | grep -o "1.0"; then
	sed -i "s/window_background_opacity = 1.0/window_background_opacity = 0.9/" $file
else
	sed -i "s/window_background_opacity = 0.9/window_background_opacity = 1.0/" $file
fi
