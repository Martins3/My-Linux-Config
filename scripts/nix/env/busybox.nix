with import <nixpkgs> { };
pkgs.stdenv.mkDerivation {
  name = "busybox";
  hardeningDisable = [ "all" ];
  buildInputs = with pkgs; [
    getopt
    flex
    bison
    gcc
    gnumake
    bc
    dpkg
    pkg-config
    binutils

    elfutils
    ncurses
    openssl
    stdenv.cc.libc
    stdenv.cc.libc.static
  ];
}
