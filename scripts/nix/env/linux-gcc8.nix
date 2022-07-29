
/* TMP_TODO 理解为什么是这个样子的 */
/* https://stackoverflow.com/questions/50277775/how-do-i-select-gcc-version-in-nix-shell */
 with import <nixpkgs> {}; {
  qpidEnv = stdenvNoCC.mkDerivation {
    name = "gcc8-env";
    buildInputs = [
        gcc8
    flex
    lzop
    pkgconfig
    ncurses
    openssl
    elfutils
    bc
    ];
  };
}
