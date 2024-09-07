{ pkgs ? import <nixpkgs> { } }:

  pkgs.stdenv.mkDerivation {
    name = "gnuefi";
    buildInputs = with pkgs; [
      gnu-efi
      pkg-config
    ];
  }
