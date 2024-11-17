# git clone https://kernel.googlesource.com/pub/scm/utils/mdadm/mdadm
{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "mdadm";
  buildInputs = with pkgs; [
    udev
  ];
}
# 无需额外配置，直接 make 就可以了
