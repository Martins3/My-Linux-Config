/* https://discourse.nixos.org/t/how-to-make-mkshell-to-use-clangs-stdenv/9484 */
with import <nixpkgs> { };
(mkShell.override { stdenv = clangStdenv; }) {
  hardeningDisable = [ "all" ];
  buildInputs = [
    pkg-config
    bpftools
    elfutils
    libbfd
    libbpf
    zstd
    libcap
    llvm
    (python3.withPackages (
      p: with p; [
        pyyaml
      ]
    ))
    # TODO 这个是需要的吗?
    linuxHeaders
    libz
  ];

# 原来系统中添加了一个 -static ，所以 ld 找不到静态库
LD_LIBRARY_PATH = "${lib.makeLibraryPath [ zstd ]}";
}
