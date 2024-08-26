{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "hello";
  buildInputs = with pkgs; [
      bison
      flex
      elfutils
      swig
      openssl
      libuuid
      gnutls
  ];
}
