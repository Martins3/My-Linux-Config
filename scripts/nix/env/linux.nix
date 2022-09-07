{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "linux-kernel-build";
  nativeBuildInputs = with pkgs; [
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
  ];
  buildInputs = with pkgs; [
    elfutils
    ncurses
    openssl
    zlib
  ];
}
