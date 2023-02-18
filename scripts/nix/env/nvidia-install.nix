let
  pkgs = import <nixpkgs> { };
in
pkgs.stdenv.mkDerivation {
  name = "nvidia installer";
  buildInputs = with pkgs; [
    ncurses
    pciutils
    xorg.libpciaccess

    autoconf
    automake
    libtool

  ];
}
