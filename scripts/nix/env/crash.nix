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
