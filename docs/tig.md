# tig 配置

经常使用 git ，每一个操作都是类似下面这种全部都敲一遍，会很累，很容易出错，而且记不住这么长的命令。
```sh
git commit -m "your awesome commit message"
```
所以有各种 git 工具加快经常性事件，比如
- [lazygit](https://github.com/jesseduffield/lazygit)
- [gitk](https://git-scm.com/docs/gitk/)
- [sublime merge](https://www.sublimemerge.com/)
- [forgit](https://github.com/wfxr/forgit)

tig 相比这些而言而言，代码开源，功能强大，界面简洁，可以集成到 vim 中使用

我的配置基本官方给出来的配置: https://github.com/jonas/tig/blob/master/contrib/vim.tigrc

## 自定义命令
```sh
bind status D ?@rm %(file)
```
表示在 status view 中 D 可以删除一个文件.
- `?` : 表示执行命令前是否咨询一下
- `@` : 表示在 background 中运行

## 配合 vim 使用
- 在 diff view 中 使用 e 可以让直接跳转到该行

## TODO
- [ ] 介绍一下 uu(x) ur ul 的使用
- [ ] 测试 cherry pick
- [ ] 测试 mrege 也是一个小问题 https://github.com/christoomey/vim-conflicted
- [ ] 还不如直接将 git.md 和 github.md 使用总结到一起
