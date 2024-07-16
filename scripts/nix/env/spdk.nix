# 参考:
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/libraries/spdk/default.nix
let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell rec {
  nativeBuildInputs = with pkgs.buildPackages; [
     nasm
     pkg-config
     yasm
    /* elfutils */
    autoconf
    autoconf-archive
    automake
    bison
    cunit
    dpdk
    flex
    fuse3
    gettext
    jansson
    lcov
    libaio
    libbsd
    libelf
    libnl
    libpcap
    libtool
    liburing
    libuuid
    ncurses
    ncurses
    numactl
    openssl
    pkg-config
    python3
    python3.pkgs.setuptools
    python3Packages.pyelftools
    zlib
  ];

  # @todo 不知道这个是什么原理?
  NIX_CFLAGS_COMPILE = "-mssse3"; # Necessary to compile.
  # otherwise does not find strncpy when compiling
  NIX_LDFLAGS = "-lbsd";

  buildInputs = with pkgs; [ ];
}

/**
  * git clone https://github.com/spdk/spdk.git
  * pushd spdk
  * git submodule update --init
  * ./configure --with-ublk
  * make
*/
