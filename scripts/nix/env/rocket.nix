{ pkgs ? import <nixpkgs> { } }:

pkgs.llvmPackages.stdenv.mkDerivation {
    name = "rocket-chip";
    buildInputs = with pkgs; [
        bison
        llvm
        verilator
        mill
        dtc # device-tree-compiler
        (python3.withPackages (p: with p; [
          setuptools
        ]))
        circt
        espresso

        # libs
        sqlite
        zlib
        zstd
    ];
      shellHook = ''
      '';
}

# 测试方法:
# git submodule update --init
# make verilog
#
# firtool: Unknown command line argument '-dedup'.  Try: 'firtool --help'
# firtool: Did you mean '--no-dedup'?
# 在 build.sc 将 --dedup 去掉即可，
