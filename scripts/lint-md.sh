#!/bin/bash

lint_md_output=$(lint-md ./docs -c .lintmdrc.json)
echo "$lint_md_output"

# Lint total 55 files, 0 warnings 1 errors
lint_md_res="${lint_md_output##*$'\n'}"
# 55 0 1
echo "lint_md_res (${lint_md_res})"
res_string=$(echo "$lint_md_res" | grep -o -E '[0-9]+')
echo "res_str : $res_string"

# read -ar res <<<"$res_string"
mapfile -t res < <(echo "$res_string")

echo "Lint-md warning : ${res[1]}"
echo "Lint-md error : ${res[2]}"

if [ "${res[1]}" != "0" ] || [ "${res[2]}" != "0" ]; then
    echo "Try to fix problem"
    lint-md -f ./*.md docs/ -c .lintmdrc.json
    echo "Please recheck Chinese document"
    exit 1
fi
