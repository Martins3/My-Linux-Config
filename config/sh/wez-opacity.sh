#!/usr/bin/env bash

set -E -e -u -o pipefail
file=/home/martins3/.dotfiles/config/wezterm.lua

if grep window_background_opacity $file | grep -o "0.8"; then
	sed -i "s/window_background_opacity = 0.8/window_background_opacity = 1.0/" $file
else
	sed -i "s/window_background_opacity = 1.0/window_background_opacity = 0.8/" $file
fi
