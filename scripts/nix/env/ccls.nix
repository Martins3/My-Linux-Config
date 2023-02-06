with import <nixpkgs> {};
let

in stdenv.mkDerivation {
  name = "llvm-env";
  nativeBuildInputs = [ cmake llvmPackages.llvm.dev ];
  buildInputs = with llvmPackages; [ libclang llvm rapidjson ];
}

# cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Debug
# cmake --build Release -j30
