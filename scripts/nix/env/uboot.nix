{ pkgs ? import <nixpkgs> { } }:

  pkgs.stdenv.mkDerivation {
    name = "hello";
    buildInputs = with pkgs; [
        bison
        flex
        elfutils
        swig
        openssl
        libuuid
        gnutls
        libGL
        libz
        glib.out
        # good 完美解决掉问题
        (python3.withPackages (p: with p; [
          setuptools
          # conda
          pip
        ]))
    ];
    # 原来需要这样包含动态库的
    # https://discourse.nixos.org/t/where-can-i-get-libgthread-2-0-so-0/16937/6
    # 尝试 nix-index 哦
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.libGL}/lib:${pkgs.glib.out}/lib:${pkgs.libz}/lib";
  }
