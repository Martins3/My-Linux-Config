#!/bin/bash

DIR=~/.SpaceVim.d/doc/
SRC=${DIR}add_docs.cpp
BIN=${DIR}addoc

function catch() {
    if [ $? -ne 0 ]; then
        echo $1
        exit 0
    fi
}

function t_1() {
    ${BIN}
}

clang++ -std=c++11 ${SRC} -o ${BIN}
catch "compile failed !"

t_1

