/* https://discourse.nixos.org/t/how-to-make-mkshell-to-use-clangs-stdenv/9484 */
with import <unstable> { };

# https://github.com/iovisor/bcc/tree/master/libbpf-tools
# 有点难
# 遇到来两个报错，随便修修，还是不行
# 1. A call to built-in function '__stack_chk_fail' is not supported.
#   - 解决方法 : Makefile 中 BPFCFLAGS := -g -O2 -Wall -fno-stack-protector
# 2. clang-11: error: cannot specify -o when generating multiple output files
#    - 不知道怎么解决，就算去掉 -o ，生成的 a.out 也有问题
# 感觉 nixos 上使用很难
(mkShell.override { stdenv = clangStdenv; }) {
  hardeningDisable = [ "all" ];
  buildInputs = [
    bpftools
    elfutils
    libbfd
    libbpf
    libcap
    llvm
  ];
}

# libbfd 和 libcap 是做啥的不知道，但是构建的过程中的确要
#
# ...                        libbfd: [ OFF ]
# ...               clang-bpf-co-re: [ on  ]
# ...                          llvm: [ on  ]
# ...                        libcap: [ OFF ]
