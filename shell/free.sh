#!/usr/bin/env bash

set -E -e -u -o pipefail

containsElementRet=true
containsElement() {
	local e match="$1"
	shift
	containsElementRet=true
	for e; do [[ $e == "$match" ]] && return 0; done
	containsElementRet=lalse
}

array=("something to search for" "a string" "test2000")
containsElement "a string" "${array[@]}"
echo $containsElementRet

containsElement "blaha" "${array[@]}"
echo $containsElementRet
