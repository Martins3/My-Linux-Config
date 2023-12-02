# 构建内核

https://rpmfusion.org/Howto/NVIDIA

太惨了，居然被删除了
https://src.fedoraproject.org/rpms/ccls

https://fedoraproject.org/wiki/How_to_use_kdump_to_debug_kernel_crashes

sudo kdumpctl reset-crashkernel
sudo systemctl enable kdump.service
sudo dnf install --enablerepo=fedora-debuginfo --enablerepo=updates-debuginfo kexec-tools crash kernel-debuginfo

## word
https://www.nerdfonts.com/font-downloads

```sh
mkdir ~/.local/share/fonts
unzip *.zip  -d ~/.local/share/fonts/
fc-cache ~/.local/share/fonts
```
