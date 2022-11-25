#!/usr/bin/env bash

lint-md ./docs/**/* -c .lintmdrc.json

if [[ $? ]]; then
  lint-md -f ./docs/**/* -c .lintmdrc.json
else
  exit 1
fi
