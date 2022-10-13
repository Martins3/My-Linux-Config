{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "kernel";
  buildInputs = with pkgs; [
    getopt
    flex
    bison
    gcc
    gnumake
    bc
    rpm
    dpkg
    pahole # bpf
    pkg-config
    binutils

    elfutils
    ncurses
    openssl
    zlib

    # selftests
    alsa-lib
    libcap
    libmnl
    libcap_ng
  ];
}
