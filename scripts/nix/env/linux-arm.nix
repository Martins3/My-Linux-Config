let
  pkgs_arm_cross = import <nixpkgs> {
    # get this config on my android
    #   nix repl
    #   builtins.currentSystem
    crossSystem = "aarch64-linux";
  };
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  buildInputs = with pkgs_arm_cross; [
    # packages for cross compiling, run on local system (x86_64)
    stdenv.cc
    # here stdenv.cc is the same with buildPackages.gcc
  ] ++ (with pkgs; [
    # packages run on local system (x86_64)
    pkgconfig
    bison
    flex
    lzop
    ncurses
    openssl
    elfutils
    bc
  ]);
}

# 编译内核的方法
# ARCH=arm64 CROSS_COMPILE=aarch64-unknown-linux-gnu- make defconfig
# ARCH=arm64 CROSS_COMPILE=aarch64-unknown-linux-gnu- make
#
# 为了让 ccls 可以正确工作，还需要修改 compile_commands.json 中的编译器为 gcc

# 以前在 Ubuntu 的 Docker 中交叉编译的方法是这个：
# ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make defconfig
# ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make
# TMP_TODO 为什么存在这个差异，调查一下
