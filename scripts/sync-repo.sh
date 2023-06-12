#!/usr/bin/env bash
set -E -e -u -o pipefail
# 每次都会下载的 repo
repos=(
	https://github.com/NixOS/nixpkgs
)
for repo in "${repos[@]}"; do
	echo "$repo"
done
