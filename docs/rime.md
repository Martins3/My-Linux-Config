# Linux 输入法配置

搜狗输入法在 Linux 上的使用体验非常差，一会出现 qt4 和 qt5 的兼容问题，一会写 syslog 将我的磁盘空间全部耗尽，我真的忍无可忍。

## 安装
- https://github.com/fcitx/fcitx-rime

安装并且使用: [plum](https://github.com/rime/plum)
```c
git clone https://github.com/rime/plum
cd plum
rime_dir="$HOME/.config/fcitx/rime" bash rime-install
```
<details> <summary>img</summary> <p align="center"> <img src="https://user-images.githubusercontent.com/16731244/158186099-eb49d51b-96b8-4656-9916-2d2fe557bc30.png" /> </p> </details>

## 配置一下 fcitx
<details> <summary>img</summary> <p align="center"> <img src="https://user-images.githubusercontent.com/16731244/158186085-78f6d595-40cf-4b3e-987a-50dca22927e3.png" /> </p> </details>

这样 `ctrl space` 唤出 rime 输入法,而 shift 切换的 rime 的中文输入和英文输入.

## 添加配置
参考了一下 [Iorest](https://github.com/Iorest/rime-setting),感觉有点庞杂,所以我自己写了[一个](https://github.com/Martins3/My-Linux-Config/tree/master/rime)

## vim 中自动切换输入法
参考 [h-hg/fcitx.nvim](https://github.com/h-hg/fcitx.nvim) 注意插件中的文档要求配置输入法的顺序
> Please confirm in `fcitx-configtool` (or `fcitx5-configtool`) that English is the first input method and Non-Latin (like Chinese) is the second input method. For rime users, please note that there must be two input methods in `fcitx` (or `fcitx5`).

## 全角英文和半角英文
不是很好截图,所以拍了一张照片,勾选其中的 `Half Width Character` 实现全角和半角的转换.
<details> <summary>img</summary> <p align="center"> <img src="https://user-images.githubusercontent.com/16731244/158184947-d299eccb-9ecb-4b6a-bea8-2769d022f33b.jpeg" width="400" /> </p> </details>

## 重启
fcitx -r

## 设置简体
在出现 ui 的时候, Fn4 可以调整, 或者使用
```plain
ctrl `
```

## 设置皮肤
默认皮肤就很简洁，没有必要浪费时间。

## 参考 && TODO
- https://github.com/BlueSky-07/Shuang 双拼練習
- https://mogeko.me/posts/zh-cn/031/
- [ ] https://sspai.com/post/63916
- [ ] 有没有自动 correction 的操作
- [ ] 如何保持总是只有 rime,似乎从 vim 切换到 chrome 中的时候,会切换成系统的英文输入法
- [ ] 似乎并不是默认进入到中文输入中的,是不是 fcitx-vim 的原因
- [ ] rime 能不能像 sogou 一样又一个明显一点的 indicator 说明当前是中文还是英文
- [ ] 安装一下计算机的词库
- [ ] 统计字数是个好东西啊，但是统计中文的行为很奇怪。
