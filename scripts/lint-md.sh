#!/usr/bin/env bash
set -E -e -u -o pipefail

if (($# == 0)); then
	set -- "docs/**/*"
fi

lint-md "$@" -c .lintmdrc.json --threads auto --suppress-warnings
