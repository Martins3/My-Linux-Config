{
  pkgs ? import <nixpkgs> { },
}:

# 各种 C 环境合集都放这里了
pkgs.llvmPackages.stdenv.mkDerivation {
  name = "C";
  buildInputs = with pkgs; [
    cmake
    libpcap
    liburing
    libtraceevent
    glib
    pkg-config
    fuse3
    # glibc.static # 可以静态编译
    # 2025-05-09 发现添加上这个，编译运行，程序会直接 crash 的。
  ];
}
