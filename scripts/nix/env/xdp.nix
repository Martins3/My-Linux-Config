let
pkgs = import <nixpkgs> { };
in
  pkgs.clangStdenv.mkDerivation {
    name = "xdp";
    buildInputs = with pkgs; [
      pkg-config
        bpftool
        libllvm
        elfutils
        autoconf
        automake
        libtool
        libpcap
        glibc_multi
        libbpf
        ];
  }
