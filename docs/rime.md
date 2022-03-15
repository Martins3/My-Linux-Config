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

![DeepinScreenshot_microsoft-edge-dev_20220314215124](https://user-images.githubusercontent.com/16731244/158186099-eb49d51b-96b8-4656-9916-2d2fe557bc30.png)

## 配置一下 fcitx
![DeepinScreenshot_microsoft-edge-dev_20220314215115](https://user-images.githubusercontent.com/16731244/158186085-78f6d595-40cf-4b3e-987a-50dca22927e3.png)

这样 `ctrl space` 唤出 rime 输入法,而 shift 切换的 rime 的中文输入和英文输入.

## 添加配置
参考了一下 [Iorest](https://github.com/Iorest/rime-setting),感觉有点庞杂.

## vim 中自动切换输入法
参考 [h-hg/fcitx.nvim](https://github.com/h-hg/fcitx.nvim) 注意插件中的文档要求配置输入法的顺序
> Please confirm in `fcitx-configtool` (or `fcitx5-configtool`) that English is the first input method and Non-Latin (like Chinese) is the second input method. For rime users, please note that there must be two input methods in `fcitx` (or `fcitx5`).

## 全角英文和半角英文
不是很好截图,所以拍了一张照片,勾选其中的 `Half Width Character` 实现全角和半角的转换.
<details> <summary>img</summary> <p align="center"> <img src="https://user-images.githubusercontent.com/16731244/158184947-d299eccb-9ecb-4b6a-bea8-2769d022f33b.jpeg" width="400" /> </p> </details>

## 重启
fcitx -r

## 设置简体
在出现 ui 的时候, Fn4 可以调整

## 设置皮肤
默认皮肤就很简洁，没有必要浪费时间。

## 参考
- https://github.com/BlueSky-07/Shuang 双拼練習
- https://mogeko.me/posts/zh-cn/031/
- [ ] https://sspai.com/post/63916
