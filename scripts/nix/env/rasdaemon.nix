# https://github.com/mchehab/rasdaemon

{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "kernel";
  buildInputs = with pkgs; [
    autoconf
    automake
    libtool
    sqlite # (if sqlite3 will be used)
    perlPackages.DBDSQLite # (if sqlite3 will be used)

    # 将这个作为基础
    bison
    flex
    pkg-config
    elfutils
    libelf
    automake
    libtool
    nasm
    pkgconf

    automake
    gcc
    git
    libelf
    zlib
    libtool
  ];
}

# autoreconf -vfi
# ./configure --enable-sqlite3  --enable-aer --enable-mce
# bear -- make -j
