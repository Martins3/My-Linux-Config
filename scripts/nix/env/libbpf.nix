/* https://discourse.nixos.org/t/how-to-make-mkshell-to-use-clangs-stdenv/9484 */
with import <nixpkgs> { };

(mkShell.override { stdenv = llvmPackages_14.stdenv; }) {
  buildInputs = [
    libbpf
  ];
}
