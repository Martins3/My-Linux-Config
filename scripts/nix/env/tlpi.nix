let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    libcap
    acl
    glibc
  ];
}
