{ pkgs ? import <nixpkgs> { } }:

# 各种 C 环境合集都放这里了
pkgs.llvmPackages.stdenv.mkDerivation {
  name = "C";
  buildInputs = with pkgs; [
      libpcap
      liburing
      libtraceevent
      glib
      pkg-config
      fuse3
  ];
}
