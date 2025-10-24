# nvim 的调试

利用 https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME 可以很容易的调试

1. 部署配置
```sh
ln -sf $HOME/.dotfiles/nvim-mini/ ~/.config/nvim-mini
ls -la ~/.config/nvim-mini
```

2. 切换环境变量
```sh
export NVIM_APPNAME=nvim-mini
```

3. 执行 nvim ，将会加载新配置
