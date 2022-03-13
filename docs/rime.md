# Linux 输入法配置

搜狗输入法在 Linux 上的使用体验非常差，一会出现 qt4 和 qt5 的兼容问题，一会写 syslog 将我的磁盘空间全部耗尽，我真的忍无可忍。
## 安装
- https://github.com/fcitx/fcitx-rime

## 添加配置
- https://github.com/Iorest/rime-setting

## 设置中文和英文输入的切换快捷键
![DeepinScreenshot_Alacritty_20220312154929](https://user-images.githubusercontent.com/16731244/158009184-9417b24c-fdfa-431c-945e-3c3bc6de2601.png)

## vim 中自动切换输入法
- use 'h-hg/fcitx.nvim'

## TODO
- [ ] 阅读配置，保存词库，同步词库
- [ ] 有皮肤吗?
- [ ] vim
- [ ] 中文英文切换的时候，不要出现弹窗，也许修改掉现在的技术方案，只有一个 rime 输入法，中文和英文都是 rime 提供。

## 值得分析的
- https://github.com/tonyfettes/coc-rime
- https://github.com/BlueSky-07/Shuang 双拼联系
