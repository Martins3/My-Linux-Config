# 构建内核

https://rpmfusion.org/Howto/NVIDIA

太惨了，居然被删除了
https://src.fedoraproject.org/rpms/ccls

https://fedoraproject.org/wiki/How_to_use_kdump_to_debug_kernel_crashes

sudo kdumpctl reset-crashkernel
sudo systemctl enable kdump.service
sudo dnf install --enablerepo=fedora-debuginfo --enablerepo=updates-debuginfo kexec-tools crash kernel-debuginfo

## 字体
https://www.nerdfonts.com/font-downloads

```sh
mkdir ~/.local/share/fonts
unzip *.zip  -d ~/.local/share/fonts/ #
fc-cache ~/.local/share/fonts
```

## edge 浏览器

```txt
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-beta.repo
sudo dnf install microsoft-edge-beta
```

## 将默认的文件系统记得换一下

btrfs 感觉问题很大啊

## 切换内核


sudo dnf copr enable kwizart/kernel-longterm-5.15 fedora-38-x86_64

https://copr.fedorainfracloud.org/coprs/kwizart/kernel-longterm-5.15/

这个方法不好用，还不如直接下载 rpm 来安装的
