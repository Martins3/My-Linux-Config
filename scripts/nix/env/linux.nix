{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "linux-kernel-build";
  buildInputs = with pkgs; [
    getopt
    flex
    bison
    gcc
    gnumake
    bc
    rpm
    dpkg
    pahole
    pkg-config
    binutils

    # selftests
    alsa-lib
    libcap
    libmnl
    libcap_ng

    elfutils
    ncurses
    openssl
    zlib
  ];
}
