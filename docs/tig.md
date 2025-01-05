# 基于 tig 的 git workflow

经常使用 git ，每一个操作都是类似下面这种全部都敲一遍，会很累，很容易出错，而且记不住这么长的命令。
```sh
git commit -m "your awesome commit message"
```
所以有各种 git 工具加快经常性事件，比如
- [lazygit](https://github.com/jesseduffield/lazygit)
- [gitk](https://git-scm.com/docs/gitk/)
- [sublime merge](https://www.sublimemerge.com/)
- [forgit](https://github.com/wfxr/forgit)
- [gitui](https://github.com/extrawurst/gitui) : 据说性能很好，但是没有尝试过

tig 相比这些而言而言，代码开源，功能强大，界面简洁，可以集成到 vim 中使用

我的配置基本官方给出来的配置: https://github.com/jonas/tig/blob/master/contrib/vim.tigrc

## 自定义命令
```sh
bind status D ?@rm %(file)
```
表示在 status view 中 D 可以删除一个文件.
- `?` : 表示执行命令前是否咨询一下
- `@` : 表示在 background 中运行

## 常见的使用
- 在 diff view 中使用 e 可以让直接编辑对应的文件
- x 来 state 和 unstate 一个文件或者 hunk
- ur 来 discard 一个 hook
- ul 来 discard 一行修改

<!-- - [ ] 测试 cherry pick -->
<!-- - [ ] 测试 mrege 也是一个小问题 https://github.com/christoomey/vim-conflicted -->
<!-- - [ ] 还不如直接将 git.md 和 github.md 使用总结到一起 -->

## 尝试下 gitui
3. 无法像 tig 一样直接查看一个文件或者一个目录的历史
3. copy 无法使用
4. 不可以调整 layout ，而且左侧的框框太大了

好处:
1. 性能
2. stage 和 unstage 原生支持
3. 搜索根据强大

- https://stackoverflow.com/questions/77841799/how-to-search-commit-body-in-gitui

<script src="https://giscus.app/client.js"
        data-repo="Martins3/My-Linux-Config"
        data-repo-id="MDEwOlJlcG9zaXRvcnkyMTUwMDkyMDU="
        data-category="General"
        data-category-id="MDE4OkRpc2N1c3Npb25DYXRlZ29yeTMyODc0NjA5"
        data-mapping="pathname"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="bottom"
        data-theme="light"
        data-lang="en"
        crossorigin="anonymous"
        async>
</script>

本站所有文章转发 **CSDN** 将按侵权追究法律责任，其它情况随意。
