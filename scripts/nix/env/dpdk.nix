let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell rec {
  nativeBuildInputs = with pkgs.buildPackages; [
    ninja
    meson
    python39Packages.pyelftools
  ];
  buildInputs = with pkgs; [ zlib ];
}
