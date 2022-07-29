# nix-env -f ./libllvm13_debug.nix -i
with (import <nixpkgs> {});
(llvmPackages_13.libllvm.override {
  debugVersion = true;
})
