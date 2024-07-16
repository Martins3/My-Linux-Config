with import <nixpkgs> {};
let
  pythonPackages = python3.pkgs;
in
  stdenv.mkDerivation rec {
    name = "bcc-env";
    buildInputs = [
      bcc
    ];
  }
