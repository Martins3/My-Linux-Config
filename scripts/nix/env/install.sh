#!/usr/bin/env bash
set -E -e -u -o pipefail
PROGDIR=$(readlink -m "$(dirname "$0")")
items=()
for file in "$PROGDIR"/*.nix; do
	items+=("$(basename "$file")")
done

file=$(printf "%s\n" "${items[@]}" | fzf)

gum confirm "Continue at [$(pwd)] with [$file]" || exit 0

if [[ $(basename "$file") == rust-best.nix ]]; then
	# 1. scripts/nix/env/rust-best.nix 需要加载当前目录中的 ./rust-toolchain.toml
	# 那么就只能用 ln ，不可以用 ln -s
  # 2. 不过 ln 是不可以 cross device 的，这个时候拷贝
	if ! ln "$PROGDIR/$file" default.nix; then
		cp "$PROGDIR/$file" default.nix
	fi
else
	ln -sf "$PROGDIR/$file" default.nix
fi

echo "use nix" >>.envrc && direnv allow
