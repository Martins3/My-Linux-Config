# https://github.com/numactl/numactl

{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "autoconf";
  buildInputs = with pkgs; [
    autoconf
    automake
    libtool
  ];
}
# ./autogen.sh
# ./configure
# bear -- make -j
# make install
