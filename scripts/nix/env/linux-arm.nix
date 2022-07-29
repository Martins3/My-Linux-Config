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
    bison
    flex
    lzop
    pkgconfig
    ncurses
    openssl
    elfutils
    bc
  ]);
}

# 编译内核的方法
# ARCH=arm64 CROSS_COMPILE=aarch64-unknown-linux-gnu- make defconfig
# ARCH=arm64 CROSS_COMPILE=aarch64-unknown-linux-gnu- make

# 正常的系统中是这个，TMP_TODO 为什么如此，调查一下
# ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make defconfig
# ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make
