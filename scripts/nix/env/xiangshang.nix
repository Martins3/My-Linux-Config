{ pkgs ? import <nixpkgs> { } }:

pkgs.llvmPackages.stdenv.mkDerivation {
    name = "xiang";
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

    ];
      shellHook = ''
      export XS_PROJECT_ROOT=$(pwd)
      export NEMU_HOME=$(pwd)/NEMU
      export AM_HOME=$(pwd)/nexus-am
      export NOOP_HOME=$(pwd)/XiangShan
      export DRAMSIM3_HOME=$(pwd)/DRAMsim3
      '';
}

# git submodule update --init --recursive DRAMsim3 NEMU NutShell nexus-am
# git submodule update --init XiangShan && make -C XiangShan init;
# cd XiangShan
# make verilog
# 但是 make 最后会有错误，对比一下 xiby1 的 config 是什么原因吧
