with import <nixpkgs> {};
pkgs.llvmPackages.stdenv.mkDerivation {
  name = "yyds tlpi";
  buildInputs = with pkgs; [
    libcap
    acl
    glibc
    # 参考: https://github.com/NixOS/nixpkgs/issues/198993
    # 存在如下的报错:
    # gcc -std=c99 -D_XOPEN_SOURCE=600 -D_DEFAULT_SOURCE -g -I../lib -pedantic -Wall -W -Wmissing-prototypes -Wno-sign-compare -Wimplicit-fallthrough -Wno-unused-parameter    cap_launcher.c ../libtlpi.a  ../libtlpi.a -lcap -lcrypt -o cap_launcher
    # /nix/store/22p5nv7fbxhm06mfkwwnibv1nsz06x4b-binutils-2.40/bin/ld: cannot find -lcrypt: No such file or directory
    libxcrypt
  ];
}
