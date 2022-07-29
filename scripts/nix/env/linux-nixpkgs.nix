# TMP_TODO https://ryantm.github.io/nixpkgs/using/overrides/
with import <nixpkgs> {}; 
linux.overrideAttrs (o: {
nativeBuildInputs=o.nativeBuildInputs ++ [ pkgconfig ncurses ];
})
