#!/usr/bin/env bash
set -E -e -u -o pipefail

function sync_dir() {
	dir=(iso vm)
	for d in "${dir[@]}"; do
		cd ~/hack/"$d"
		rsync -avzh --filter="dir-merge,- .gitignore" "$(pwd)/" martins3@10.0.0.2:"$(pwd)"
	done
}

function sync_guest(){
		rsync openEuler-23.03-x86_64-dvd.*  martins3@10.0.0.2:~/hack/vm
}

rsync -avzh --filter="dir-merge,- .gitignore" martins3@10.0.0.1:/home/martins3/core/vn ~/core/vn
