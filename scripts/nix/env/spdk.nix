# 参考:
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/libraries/spdk/default.nix
let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell rec {
  nativeBuildInputs = with pkgs.buildPackages; [
    cunit
    dpdk
    libaio
    libbsd
    libuuid
    numactl
    openssl
    ncurses
    python3
    lcov
    /* elfutils */
    python3Packages.pyelftools
  ];

  # @todo 不知道这个是什么原理?
  NIX_CFLAGS_COMPILE = "-mssse3"; # Necessary to compile.
  # otherwise does not find strncpy when compiling
  NIX_LDFLAGS = "-lbsd";

  buildInputs = with pkgs; [ ];
}

/**
  * git submodule update --init
  * ./configure
  * make
*/
