# failed 总是交叉编译的 gcc 需要手动编译，非常烦人的哇。
/* (with import <nixpkgs> {crossSystem="aarch64-linux";}; stdenv.cc) */

let
  pkgs_arm_cross = import <nixpkgs> {
    # get this config on my android
    #   nix repl
    #   builtins.currentSystem
    crossSystem = "aarch64-linux";
  };
  pkgs_arm_native = import <nixpkgs> {
    localSystem = "aarch64-linux";
    crossSystem = "aarch64-linux";
  };
  pkgs = import <nixpkgs> { };
in
  /* pkgs.mkShell { */
  /*   buildInputs = with pkgs_arm_cross; [ */
  /*     # packages for cross compiling, run on local system (x86_64) */
  /*     stdenv.cc */
  /*     # here stdenv.cc is the same with buildPackages.gcc */
  /*   ] ++ (with pkgs; [ */
  /*     # packages run on local system (x86_64) */
  /*     qemu */
  /*   ]); */
  /* } */
{
  qpidEnv = pkgs_arm_cross.stdenvNoCC.mkDerivation {
    name = "gcc8-env";

    buildInputs = with pkgs_arm_cross; [
      # packages for cross compiling, run on local system (x86_64)
      gcc10
      # here stdenv.cc is the same with buildPackages.gcc
    ] ++ (with pkgs; [
      # packages run on local system (x86_64)
      /* qemu */
    ]);
    /* buildInputs = [ */
    /*     gcc8 */
    /*     bison */
    /*     flex */
    /*     lzop */
    /*     pkgconfig */
    /*     ncurses */
    /*     openssl */
    /*     # https://groups.google.com/g/linux.gentoo.user/c/IuL41BqSpNE?pli=1 */
    /*     # https://www.spinics.net/lists/kernel/msg3797871.html */
    /*     /1* "elfutils-0.185" *1/ */
    /*     bc */
    /*     # TMP_TODO 反正都是需要增加一个 patch 的，不如增加上一个这个： */
    /*     # https://mudongliang.github.io/2021/01/20/error-new-address-family-defined-please-update-secclass_map.html */
    /*     # myPkg */
    /* ]; */
  };

}
