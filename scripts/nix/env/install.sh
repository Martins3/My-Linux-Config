#!/usr/bin/env bash
set -E -e -u -o pipefail
PROGDIR=$(readlink -m "$(dirname "$0")")
items=()
for file in "$PROGDIR"/*.nix; do
	items+=("$(basename "$file")")
done

file=$(printf "%s\n" "${items[@]}" | fzf)

gum confirm "Continue at [$(pwd)] with [$file]" || exit 0

ln -s "$PROGDIR/$file" default.nix
echo "use nix" >>.envrc && direnv allow
