# 问题

- [ ] system.nix 中，如果不去定义任何 users 的东西，会如何？
  - [ ] 不去安装 home manager 如何?

## 添加
```sh
nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-21.11 nixos # 对于NixOS
nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-21.11 nixpkgs # 对于Nix
# 添加home manager 源
nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
nix-channel --update
```

## [ ] 两个 switch 应该是分别添加的

```sh
sudo nixos-rebuild switch # 仅NixOS
# 安装home-manager
nix-shell '<home-manager>' -A install
home-manager switch
```
