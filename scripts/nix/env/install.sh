#!/usr/bin/env bash
set -E -e -u -o pipefail

echo "┌─────────────────────────────────────────┐"
echo "│  DEPRECATION NOTICE                     │"
echo "├─────────────────────────────────────────┤"
echo "│  This old script is deprecated.         │"
echo "│  Please use the new system instead:     │"
echo "│                                         │"
echo "│  nix run ~/.dotfiles/nix/envs           │"
echo "│                                         │"
echo "│  Or directly:                           │"
echo "│  ~/.dotfiles/nix/envs/select-env.sh     │"
echo "└─────────────────────────────────────────┘"
echo

# Give user a chance to read the message
sleep 3

# Run the new script
~/.dotfiles/nix/envs/select-env.sh