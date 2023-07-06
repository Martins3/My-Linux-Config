# openEuler 虚拟机测试

## 安装配置
将分区从 LVM 修改为普通配置。


## 安装之后的手动配置
1. 配置网络
```sh
cd /etc/sysconfig/network-scripts/
ip a
```
检查下网卡名称

2. 拷贝公钥
```sh
ssh-copy-id -p 5556 root@localhost
```

3. 删除密码
```sh
passwd --delete root
```

4. 启动代理
```sh
export https_proxy=http://10.0.2.2:8889
export http_proxy=http://10.0.2.2:8889
export HTTPS_PROXY=http://10.0.2.2:8889
export HTTP_PROXY=http://10.0.2.2:8889
export ftp_proxy=http://10.0.2.2:8889
export FTP_PROXY=http://10.0.2.2:8889
```

5. 将 initramfs 拷贝出来

进入到 guest 中:
```sh
scp initramfs-6.1.19-7.0.0.17.oe2303.x86_64.img martins3@10.0.2.2:/home/martins3/hack/vm/iso-name-initramfs.img
```
