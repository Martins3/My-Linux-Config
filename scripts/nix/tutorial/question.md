```c
environment.systemPackages = with pkgs; [
```
- 在一个文件中不能重复定义， /etc/nixos/configuration.nix 中已经定义过一次

## gcc8
```nix
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
```

## gcc8 arm

```nix
# failed
let
    pkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/66c745e30d26ee30de4a6fa4dfc7862b48ee2697.tar.gz";
    }) {};

    myPkg = pkgs.elfutils;
in

 with import <nixpkgs> {}; {
  qpidEnv = stdenvNoCC.mkDerivation {
    name = "gcc8-env";
    buildInputs = [
        gcc8
        bison
        flex
        lzop
        pkgconfig
        ncurses
        openssl
        # https://groups.google.com/g/linux.gentoo.user/c/IuL41BqSpNE?pli=1
        # https://www.spinics.net/lists/kernel/msg3797871.html
        /* "elfutils-0.185" */
        bc
        # TMP_TODO 反正都是需要增加一个 patch 的，不如增加上一个这个：
        # https://mudongliang.github.io/2021/01/20/error-new-address-family-defined-please-update-secclass_map.html
        myPkg
    ];
  };
}
```

## 如何理解 '<>'

nix-shell '<home-manager>' -A install

## 差别
nix-env -f ./libllvm13_debug.nix -i

nix-shell # 当目录中存在 default.nix 的时候

## nix develop 是做什么的

## 我记得曾经有一个 vim 有 nix 的配置的

## 如何安装 `kvm_stat`
- https://command-not-found.com/kvm_stat
o


## 如何交叉编译 ARM 的 QEMU
- 到底是否存在 aarch64-unknown-linux-gnu-pkg-config
  - https://www.google.com.hk/search?q=aarch64-unknown-linux-gnu-pkg-config&oq=aarch64-unknown-linux-gnu-pkg&aqs=edge.0.69i59j69i57j0i546l5j69i60l2.5563j0j1&sourceid=chrome&ie=UTF-8
- 也许阅读一下，ARM kvm 无法打开的原因是什么，也许根本就不是交叉编译的问题。
