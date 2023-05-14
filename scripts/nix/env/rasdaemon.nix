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
    yacc
    bison
    flex
    pkgconfig
    elfutils
    libelf
    autoconf
    automake
    libtool
    nasm
    pkgconf

    autoconf
    automake
    gcc
    git
    libelf
    libtool
  ];
}

# autoreconf -vfi
# ./configure --enable-sqlite3  --enable-aer --enable-mce
# bear -- make -j
