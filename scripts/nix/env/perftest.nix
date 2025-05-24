{
  pkgs ? import <nixpkgs> { },
}:

pkgs.llvmPackages.stdenv.mkDerivation {
  name = "perftest";
  hardeningDisable = [ "all" ];
  buildInputs = with pkgs; [
    cmake
    pkg-config
    autoconf pkgconf automake libtool
    rdma-core
    pciutils
  ];
}
# 参考 README 中的，不过需要先把 rdma-core 的代码放到正确的位置
# ./autogen.sh
# ./configure
# make
# make install

# fedora 中需要提前把 rdma-core-devel 配置好
# sudo yum install rdma-core-devel
# 或者参考这个东西来配置本地的库 LT_SYS_LIBRARY_PATH
# 
# 但是存在这个东西 : /usr/include/infiniband/verbs.h 
