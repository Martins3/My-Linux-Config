# failed
let
    pkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/66c745e30d26ee30de4a6fa4dfc7862b48ee2697.tar.gz";
    }) {};

    myPkg = pkgs.elfutils;
in

 with import <nixpkgs> {}; {
  qpidEnv = stdenvNoCC.mkDerivation {
    name = "gcc8-env";
    buildInputs = [
        gcc8
        bison
        flex
        lzop
        pkgconfig
        ncurses
        openssl
        # https://groups.google.com/g/linux.gentoo.user/c/IuL41BqSpNE?pli=1
        # https://www.spinics.net/lists/kernel/msg3797871.html
        /* "elfutils-0.185" */
        bc
        # TMP_TODO 反正都是需要增加一个 patch 的，不如增加上一个这个：
        # https://mudongliang.github.io/2021/01/20/error-new-address-family-defined-please-update-secclass_map.html
        myPkg
    ];
  };
}
