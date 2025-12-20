# 执行 code/qemu/bios_build.sh 来操作
{ pkgs ? import <nixpkgs> { } }:

  pkgs.stdenv.mkDerivation {
    name = "edk2";
    buildInputs = with pkgs; [
        bison
        libuuid
        nasm
        xorg.libX11
        xorg.libXext
    ];
      hardeningDisable = [ "format" "fortify" ];
  }
