## Changelog

### 2022
本配置之前一直是基于 [spacevim](https://spacevim.org/) spacevim 的，移除的原因主要是因为:
- spacevim 的配置很多都是 vimscript 写的，我几乎看不懂，出现了问题无法快速独立解决
- spacevim 为了兼容 vim，一些插件的选择和我有冲突，比如包管理器(dein.vim -> packer.nvim) 和文件树(defx -> nvim-tree)

将 Fn 相关的快捷键全部去掉了:
- 需要移动手掌，不是很高效
- 有的键盘是没有 Fn 键的，按 Fn 键需要低效的组合键

### 2022.8
- 现在仓库的内容不只是 neovim 相关的，还有 nixos 以及其他的各种配置，现在将所有的 vim 配置都放到 nvim 目录下了。

### 2022.9
将 ccls 替换为 clangd，虽然我是 MaskRay 的忠实粉丝，但是:
  - ccls 最近更新的比较慢
  - clangd 无需额外的插件实现高亮

### 2023.2
将 clangd 换回来 ccls，将相关问题总结到了。
