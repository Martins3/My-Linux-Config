# Rime 输入法

搜狗输入法在 Linux 上的使用体验非常差，一会出现 qt4 和 qt5 的兼容问题，一会写 syslog 将我的磁盘空间全部耗尽，我真的忍无可忍。

## 安装
- 安装[rime](https://github.com/fcitx/fcitx-rime)

- 安装并且使用: [plum](https://github.com/rime/plum)
```sh
git clone https://github.com/rime/plum
cd plum
rime_dir="$HOME/.config/fcitx/rime" bash rime-install
```

## 配置一下 fcitx
<details> <summary>img</summary> <p align="center"> <img src="https://user-images.githubusercontent.com/16731244/158186085-78f6d595-40cf-4b3e-987a-50dca22927e3.png" /> </p> </details>

这样 `ctrl space` 唤出 rime 输入法,而 shift 切换的 rime 的中文输入和英文输入.

## 添加自己的配置
参考了一下 [Iorest](https://github.com/Iorest/rime-setting)，感觉有点庞杂，所以我自己写了[一个](https://github.com/Martins3/My-Linux-Config/tree/master/rime)

## 重启
fcitx -r

## 设置
在出现 ui 的时候, Fn4 可以调整, 或者使用
```txt
ctrl `
```
## 添加词库

参考:
- https://anclark.github.io/2020/11/23/Struggle_with_Linux/%E7%BB%99RIME%E4%B8%AD%E5%B7%9E%E9%9F%B5%E6%B7%BB%E5%8A%A0%E8%AF%8D%E5%BA%93/
- https://www.jianshu.com/p/300bbe1602d4

1. 在 `luna_pinyin_simp.custom.yaml` 中增加
```yaml
  translator:
    dictionary : luna_pinyin.my_words
```
2. 创建 `luna_pinyin.my_words.dict.yaml`
3. 增加 `luna_pinyin.genshin.dict.yaml` ，其头需要有:
```yaml
---
name: luna_pinyin.genshin
version: "1.0"
sort: by_weight
use_preset_vocabulary: true
...
```

获取词库:
- https://github.com/studyzy/imewlconverter : 装换

## 设置皮肤
默认皮肤就很简洁，没有必要浪费时间。

## Mac 中
- https://rime.im/download/
- 配置只是地址不同而已，可以参考
- 使用 rime/mac-install.sh 安装，其实也就是地址不同而已
  - rime/squirrel.custom.yaml 中配置其中的

为了可以在 vim 中自动切换，使用上: https://github.com/xcodebuild/fcitx-remote-for-osx

```sh
git clone https://github.com/xcodebuild/fcitx-remote-for-osx.git
cd fcitx-remote-for-osx
./build.py build all abc
# squirrel for example
cp ./fcitx-remote-squirrel-rime-upstream /usr/local/bin/fcitx-remote
```

`TMP_TODO` 不知道为什么，mac 中默认没有 /usr/local/bin 这个目录，需要手动创建和修改 PATH
```sh
export PATH="$PATH:/usr/local/bin"
```

原理:
- 在终端中运行 `remote-fcitx -c` 和 `remote-fcitx -o`
- 手动切换输入法，然后运行 `remote-fcitx` ，观察结果。

## 参考 && TODO
- https://github.com/BlueSky-07/Shuang 双拼練習
- https://mogeko.me/posts/zh-cn/031/
- [ ] https://sspai.com/post/63916
- [ ] 有没有自动 correction 的操作
- [ ] 如何保持总是只有 rime,似乎从 vim 切换到 chrome 中的时候,会切换成系统的英文输入法
- [ ] rime 能不能像 sogou 一样又一个明显一点的 indicator 说明当前是中文还是英文
- [ ] 统计字数是个好东西啊，但是统计中文的行为很奇怪。
