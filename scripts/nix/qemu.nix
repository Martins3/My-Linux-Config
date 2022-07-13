let
pkgs = import <nixpkgs> {
};
in
pkgs.mkShell rec {
  nativeBuildInputs = with pkgs.buildPackages; [
    pkgconfig
    ninja
    glib
    pixman
    xorg.libX11.dev
    rdma-core
   ];
  buildInputs = with pkgs; [ zlib ];
}
