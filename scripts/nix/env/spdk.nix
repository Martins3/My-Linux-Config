# 参考:
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/libraries/spdk/default.nix
{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "spdk";

  version = "24.09";

  nativeBuildInputs = with pkgs; [
    python3
    python3.pkgs.pip
    python3.pkgs.setuptools
    python3.pkgs.wheel
    python3.pkgs.wrapPython
    python3.pkgs.pyelftools
    pkg-config
    ensureNewerSourcesForZipFilesHook
  ];

  buildInputs = with pkgs; [
    elfutils
    cunit
    dpdk
    fuse3
    jansson
    libaio
    libbsd
    liburing
    elfutils
    libuuid
    libpcap
    libnl
    numactl
    openssl
    ncurses
    zlib
    zstd
  ];

  propagatedBuildInputs  = with pkgs; [ 
    python3.pkgs.configshell
  ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = "-mssse3"; # Necessary to compile.
  # otherwise does not find strncpy when compiling
  env.NIX_LDFLAGS = "-lbsd";

}
