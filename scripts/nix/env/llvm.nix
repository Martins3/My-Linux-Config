with import <nixpkgs> { };
clangStdenv.mkDerivation {
  name = "clang-nix-shell";
  buildInputs = [
  ];
}
# 1. llvm-propject 应该是不需要使用什么外部依赖的，这个只是将
# 2. 编译 cland 的方法
# mkdir build && cd build
# cmake ../llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra"
# cmake --build . --target clangd -j31
