{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "kernel";
  buildInputs = with pkgs; [
    autoconf
    automake
    libtool
    bison
    zlib
    ncurses
    lzo
  ];
}

# ./configure -x lzo
# 可以解决 crash: compressed kdump: uncompress failed: no lzo compression support
# make
# git apply crash.patch # 只是修改几个路径问题就可以了
# @todo 提交给社区？
