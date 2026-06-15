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
    zstd
  ];
}

# git clone https://github.com/crash-utility/crash

# ./configure -x lzo
# make -j32
# 完全理解之后提交给 nixos 社区吧？
