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
        # good 完美解决掉问题
        (python3.withPackages (p: with p; [
          setuptools
        ]))
    ];
  }
