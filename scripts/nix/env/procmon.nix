with import <nixpkgs> { };
clangStdenv.mkDerivation {
  hardeningDisable = [ "all" ];

  name = "procman-dev";
  buildInputs = [
    libbpf
    clang
    linuxHeaders
    pkg-config 
    elfutils 
    zlib 
    pkg-config
  ];
}
# 不知道咋解决， bpf_helpers.h
# 似乎这个文件是在 tools/lib/bpf/bpf_helpers.h 中的
# 而且 ls -l /nix/store/*-libbpf-*/include/bpf/bpf_helpers.h 
# 也是有输出的

# https://github.com/microsoft/ProcMon-for-Linux/blob/main/BUILD.md
# git clone https://github.com/Sysinternals/ProcMon-for-Linux.git
# cd ProcMon-for-Linux
# mkdir build
# cd build
# cmake ..
# make
