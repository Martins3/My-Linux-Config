#!/usr/bin/env bash

lint-md ./docs/*.md -c .lintmdrc.json

if [[ $? ]] ;then
  lint-md -f ./docs/*.md -c .lintmdrc.json
else
  exit 1
fi
