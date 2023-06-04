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

修改 alpine.sh 中的
- 构建 initramfs
- docs/qemu/sh/alpine.sh
