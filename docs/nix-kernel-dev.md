# 记录下 nixos 下 kernel 开发的问题

## fio 无法使用 iouring 的 engine

```txt
[sudo] password for martins3:
fio: engine liburing not loadable
fio: failed to load engine
fio: file:ioengines.c:134, func=dlopen, error=liburing: cannot open shared object file: No such file or directory
```

参考 https://elatov.github.io/2022/01/building-a-nix-package/
手动编译 : https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/system/fio/default.nix

检查自己
```txt
🤒  ldd fio
        linux-vdso.so.1 (0x00007ffdeea6c000)
        libz.so.1 => /nix/store/xbm6sj00r5kxvpwf34vysiij5zn3i3mw-zlib-1.2.13/lib/libz.so.1 (0x00007f8fe3ab6000)
        libm.so.6 => /nix/store/vnwdak3n1w2jjil119j65k8mw1z23p84-glibc-2.35-224/lib/libm.so.6 (0x00007f8fe39d6000)
        libmvec.so.1 => /nix/store/vnwdak3n1w2jjil119j65k8mw1z23p84-glibc-2.35-224/lib/libmvec.so.1 (0x00007f8fe38da000)
        libaio.so.1 => /nix/store/qxffmwkzyh3vskafbf96sq4hzrsd2qwz-libaio-0.3.113/lib/libaio.so.1 (0x00007f8fe38d5000)
        libpthread.so.0 => /nix/store/vnwdak3n1w2jjil119j65k8mw1z23p84-glibc-2.35-224/lib/libpthread.so.0 (0x00007f8fe38d0000)
        libdl.so.2 => /nix/store/vnwdak3n1w2jjil119j65k8mw1z23p84-glibc-2.35-224/lib/libdl.so.2 (0x00007f8fe38c9000)
        libc.so.6 => /nix/store/vnwdak3n1w2jjil119j65k8mw1z23p84-glibc-2.35-224/lib/libc.so.6 (0x00007f8fe3600000)
        /nix/store/vnwdak3n1w2jjil119j65k8mw1z23p84-glibc-2.35-224/lib/ld-linux-x86-64.so.2 => /nix/store/vnwdak3n1w2jjil119j65k8mw1z23p84-glibc-2.35-224/lib64/ld-linux-x86-64.so.2 (0x00007f8fe3ad
6000)
```

修改 dlopen_ioengine 中的代码，让其去 load libaio，结果报错如下
```txt
fio: file:ioengines.c:135, func=dlopen, error=libaio: cannot open shared object file: No such file or directory
```
看来是搜索机制又问题。

参考 https://github.com/Nuitka/Nuitka/issues/1520
使用这种方法获取到;
```txt
ldconfig -C out.txt
ldconfig -C out.txt -p
```

最后为了使用 io_uring，手动编译，尝试使用 t 目录下的这个:
```sh
sudo ./io_uring /dev/nvme0n1p1
```

阅读一下 : https://matklad.github.io/2022/03/14/rpath-or-why-lld-doesnt-work-on-nixos.html

## linuxHeaders
不知道这个包是做啥的

## 为什么构建模块还需要额外的 kernel.dev 包，这里到底包含了什么

```txt
nix-shell '<nixpkgs>' -A linuxPackages_latest.kernel.dev --command " make -C $(nix-build -E '(import <nixpkgs> {}).linuxPackages_latest.kernel.dev' --no-out-link)/lib/modules/*/build M=""$(pwd)"" modules"
```

## 太牛了，这个人几乎将 nix 上构建内核所有问题都解决了?

- https://github.com/jordanisaacs/kernel-module-flake

## 类似
tools/power/cpupower/ 这个需要在一个普通的 fedora 环境中编译
