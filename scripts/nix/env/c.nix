{ pkgs ? import <nixpkgs> { } }:

pkgs.llvmPackages.stdenv.mkDerivation {
  name = "test c";
  buildInputs = with pkgs; [
      libpcap
      liburing
      glib
      pkg-config
  ];
}

