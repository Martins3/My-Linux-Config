# 问题
- [x] system.nix 中，如果不去定义任何 users 的东西，会如何？
  - 似乎问题不大
- [ ] 不去安装 home manager 如何?

## 添加一个新的用户

```sh
useradd -c 'Eelco Dolstra' -m eelco
passwd eelco
```

## 添加
```sh
nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-21.11 nixos # 对于NixOS
nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-21.11 nixpkgs # 对于Nix
# 添加home manager 源
nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
nix-channel --update
```

##  两个 switch 是可以分别添加

```sh
sudo nixos-rebuild switch # 仅NixOS
# 安装home-manager
nix-shell '<home-manager>' -A install
home-manager switch
```
这些所有的操作都是可以在 su - 下执行，除了

```plain
home-manager switch
```

## 网络代理
似乎之要是 su - 之后添加 export 才会影响 sudo 命令的 export 吗 ?
每次进入之后都是需要增加代理的

## 遇到的问题
- file 'home-manager' was not found in the Nix search path
  - 只有更新来 channel 之后才可以安装 hoem manager
  - https://github.com/nix-community/home-manager/issues/487

## 记录
- [ ] 似乎只是 import 来一下 system.nix 之后，然后就感觉是完全的重新编译
- nix-shell -p htop
- 似乎 system.nix 中的清华镜像是有问题的
  - [ ] 对于 system.nix 的任何修改是不是都需要进行一次 nixos-rebuild switch
- /etc/nixos/configuration.nix 还是不要进行修改了
