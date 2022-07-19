## compile linux kernel

编写内核的时候，需要制定正确
- https://github.com/NixOS/nixpkgs/issues/91609


https://github.com/a13xp0p0v/kernel-build-containers

kernel-build-containers git:(master) ✗ docker run -it --rm -u $(id -u):$(id -g) -v /home/martins3/linux-4.18-arm:/home/martins3/src ke
rnel-build-container:gcc-7

> -t 选项让 Docker 分配一个伪终端（pseudo-tty）并绑定到容器的标准输入上， -i 则让容器的标准输入保持打开。
> https://stackoverflow.com/questions/32269810/understanding-docker-v-command

编译之后，在 host 中执行 ./script/clang-tools/gen-compile-commands.py

可能需要将 compile-commands.json 中将 aarch-gnu-gcc 替换为 gcc，否则 ccls 拒绝开始索引。
