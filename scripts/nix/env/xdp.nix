let
pkgs = import <nixpkgs> { };
in
pkgs.llvmPackages.stdenv.mkDerivation {
  name = "xdp";
  buildInputs = with pkgs; [
      pkg-config
      bpftool
      libllvm
      elfutils
      autoconf
      automake
      libtool
      libpcap
      glibc_multi
      libbpf

      libcap
      libbfd
  ];
}


# https://github.com/xdp-project/xdp-tutorial
# 似乎因为 clang 的升级，导致编译有报错
# https://maskray.me/blog/2023-08-25-clang-wunused-command-line-argument
# 需要将将其中的 Werror 去掉
# sed -i "s/-Werror//g" lib/Makefile common/common.mk lib/libbpf/src/Makefile
