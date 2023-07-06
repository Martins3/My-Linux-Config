# Guest OS 初始化

暂时尝试过使用 cloud-init 或者 nixos 来构建 Guest 机器，但是最后发现太难 hacking 了。


# 基本设计

将参数分离开，组合测试

- corn list
- corn setup
- corn execute # 使用 ansible 来自动控制
- corn avocado # 使用 avocado 来进行测试

## 编译 ubuntu 内核 : 没太大必要，因为编译 rpm 也非常快
```txt
GEN     debian
Using default distribution of 'unstable' in the changelog
Install lsb-release or set $KDEB_CHANGELOG_DIST explicitly
dpkg-buildpackage -r"fakeroot -u" -a$(cat debian/arch)  -b -nc -uc
dpkg-buildpackage: info: source package linux-upstream
dpkg-buildpackage: info: source version 6.3.0-rc1-00002-g8ca09d5fa354-dirty-169
dpkg-buildpackage: info: source distribution unstable
dpkg-buildpackage: info: source changed by martins3 <martins3@nixos>
dpkg-architecture: warning: specified GNU system type x86_64-linux-gnu does not match CC system type x86_64-unknown-linux-gnu, try setting a correct CC environment variable
dpkg-buildpackage: info: host architecture amd64
 dpkg-source --before-build .
dpkg-source: info: using options from linux/debian/source/local-options: --diff-ignore --extend-diff-ignore=.*
dpkg-checkbuilddeps: error: cannot open /var/lib/dpkg/status: No such file or directory
dpkg-buildpackage: warning: build dependencies/conflicts unsatisfied; aborting
dpkg-buildpackage: warning: (Use -d flag to override.)
make[1]: *** [scripts/Makefile.package:127: bindeb-pkg] Error 3
make: *** [Makefile:1657: bindeb-pkg] Error 2
```
借用 https://github.com/a13xp0p0v/kernel-build-containers 的实现。

https://wiki.debian.org/BuildADebianKernelPackage
参考:
 make -j`nproc` bindeb-pkg

不知道为什么，还是这个错误:
```txt
  SYNC    include/config/auto.conf.cmd
make[2]: scripts/kconfig/conf: No such file or directory
make[2]: *** [scripts/kconfig/Makefile:77: syncconfig] Error 127
make[1]: *** [Makefile:693: syncconfig] Error 2
make: *** [Makefile:794: include/config/auto.conf.cmd] Error 2
```

## [x] build docker 镜像还是存在问题的
sudo apt install dpkg-dev rsync kmod cpio

## [x] 验证一下，是否可以用安装

.rw-r--r-- 8.9M root  9 Mar 17:08  linux-headers-6.3.0-rc1-00002-g8ca09d5fa354_6.3.0-rc1-00002-g8ca09d5fa354-4_amd64.deb
.rw-r--r--  13M root  9 Mar 17:08  linux-image-6.3.0-rc1-00002-g8ca09d5fa354_6.3.0-rc1-00002-g8ca09d5fa354-4_amd64.deb
.rw-r--r-- 1.3M root  9 Mar 17:08  linux-libc-dev_6.3.0-rc1-00002-g8ca09d5fa354-4_amd64.deb

虽然没有 debuginfo 包，但是我已经持有了 vmlinux ，其实无所谓

### 实际上，我们发现，只要是
1. make defconfig kvm_guest.config 几乎任何内核都可以拉起来的
2. 就是编译的内核有点大，不知道为什么。

## 需求
### 使用 grubby 自动切换内核，修改 kernel cmdline
```sh
sudo grubby --update-kernel=ALL --args="nokaslr console=ttyS0,9600 earlyprink=serial"
```
### 删除 guest 密码

### guest 中 oh-my-zsh 的基本命令

## 自动启动嵌套虚拟化
```c
function share() {
	cat <<'EOF' >/etc/systemd/system/nested.service
[Unit]
Description=nested virtualization setup

[Service]
Type=oneshot
ExecStart=/root/core/vn/docs/qemu/sh/alpine.sh

[Install]
WantedBy=getty.target
EOF

systemctl enable nested
}
```

## 增加 edk2 的环境搭建

## 使用 libvirt 也是可以装系统的，但是需要 ovs

## 打包方式
```txt
Kernel packaging:
  rpm-pkg             - Build both source and binary RPM kernel packages
  srcrpm-pkg          - Build only the source kernel RPM package
  binrpm-pkg          - Build only the binary kernel RPM package
```

# corn

一键 hacking 环境，收集各种 hacking 环境的脚本:
- avocado
- ansible
- grafana
- libvirt
- ovs
- perf / kvm_stat
- QEMU 调试
- [ ] 虚拟机的自动安装
  - [ ] avocado
- [ ] core latency
- [ ] cache latency
- [ ] numa latency
- [ ] 各种 perf ，bpftrace，ftrace 之类的
- [ ] 错误注入


## [ ] python perf 有点问题

## perf 脚本

## dracut 生成规则是什么
安装系统和安装驱动的过程中，

了解下这里面的参数:
- https://man7.org/linux/man-pages/man7/dracut.cmdline.7.html

```txt
       The traditional root=/dev/sda1 style device specification is
       allowed, but not encouraged. The root device should better be
       identified by LABEL or UUID. If a label is used, as in
       root=LABEL=<label_of_root> the initramfs will search all
       available devices for a filesystem with the appropriate label,
       and mount that device as the root filesystem.
       root=UUID=<uuidnumber> will mount the partition with that UUID as
       the root filesystem.
```
忽然意识到，实际上，kernel 的参数修改成为这个样子会更加好。

## 其实是两者都有问题:

## 调试一下 udev
journalctl -u systemd-udevd.service

## dracut 的源码可以分析下，主要是 dracut install 中，还是非常简单的

## 能否让 ci 运行在 github ci 中？
或者提交给 github，让本地的 ci 自动检测

## 能否直接访问网络

## 搭建 bios 调试环境

## 测试 cpu 和内存的热插拔

## 一些 Guest 的细节问题

- oe20.04 的网卡无法自动打开

将 /etc/sysconfig/network-scripts/enp1s0 中的 onboot 修改为 yes

## 嵌套虚拟机化的支持
- 继续使用 oe 来测试
- 使用 Guest 自动登录的为 tmux 的方法
- 自动备份机制
  - 真的需要使用逐个字节拷贝的方式吗？qemu 存在什么好的机制来辅助吗？

### 测试嵌套虚拟化的性能问题

## jenkins 的 node 是本地的虚拟机，而且本地虚拟机被 cgroup 约束

## 虚拟机中搭建这个
https://github.com/meienberger/runtipi


## 参考 goffinet 的 packer 脚本
- https://github.com/goffinet/packer-kvm
- https://github.com/goffinet/virt-scripts

```txt
qemu-system-x86  141151  141073    0 /home/martins3/core/qemu/build/qemu-system-x86_64 -vnc 127.0.0.1:26 -drive file=artifacts/qemu/centos9/packer-cen
tos9,if=virtio,cache=none,discard=unmap,format=qcow2 -drive file=/home/martins3/.cache/packer/7df0e601c1b6b1d629ebd8ddb382c34f976417d6.iso,media=cdrom
 -netdev user,id=user.0,hostfwd=tcp::4053-:22 -cpu host -boot once=d -name packer-centos9 -machine type=pc,accel=kvm -device virtio-net,netdev=user.0
-m
```

尝试一下下面的集中方法:
- https://github.com/linuxkit/linuxkit
- https://fedoraproject.org/wiki/Changes/OstreeNativeContainerStable
- https://coreos.github.io/rpm-ostree/container/
