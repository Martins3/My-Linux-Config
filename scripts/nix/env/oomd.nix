# https://github.com/numactl/numactl

{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "autoconf";
  buildInputs = with pkgs; [
    pkg-config
    jsoncpp
  ];
}
