# wget https://man7.org/tlpi/code/download/tlpi-220912-dist.tar.gz
let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    libcap
    acl
  ];
}
