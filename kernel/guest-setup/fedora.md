# 构建内核
sudo dnf install kernel-devel-$(uname -r)

https://rpmfusion.org/Howto/NVIDIA

太惨了，居然被删除了
https://src.fedoraproject.org/rpms/ccls

https://fedoraproject.org/wiki/How_to_use_kdump_to_debug_kernel_crashes

sudo kdumpctl reset-crashkernel
sudo systemctl enable kdump.service
sudo dnf install --enablerepo=fedora-debuginfo --enablerepo=updates-debuginfo kexec-tools crash kernel-debuginfo
