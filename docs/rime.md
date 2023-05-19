# Rime 输入法

我使用 Rime 输入法并不是其各种高级功能，我之前一直使用搜狗，但是有一次搜狗崩溃了，
忍无可忍，就换成 Rime 了。但是我发现 Rime 的输入法的门槛很高，这里简单记录下配置过程。

## 安装
- 安装 : [rime](https://github.com/fcitx/fcitx-rime)
- 安装并且使用: [plum](https://github.com/rime/plum)
```sh
git clone https://github.com/rime/plum
CONFIG_DIR=$HOME/.local/share/fcitx5/rime/
rime_dir="$CONFIG_DIR" bash rime-install
```

## 配置 fcitx5
<p align="center"> <img src="https://user-images.githubusercontent.com/16731244/158186085-78f6d595-40cf-4b3e-987a-50dca22927e3.png" />

这样 `ctrl space` 唤出 rime 输入法, 而 shift 切换的 rime 的中文输入和英文输入。

## 从 雾凇拼音 中增加词库

项目地址: https://github.com/iDvel/rime-ice

其他的配置一时无法全部消化吸收，
仅仅拷贝其中的 cn_dicts 来扩充自己的词库。

## 配置简单说明
| 文件                           | 说明                         |
|--------------------------------|------------------------------|
| linux-install.sh               | 简单的安装脚本               |
| default.custom.yaml            | 基础配置，例如候选词的个数   |
| luna_pinyin.martins3.dict.yaml | 我自己增加的词汇             |
| luna_pinyin.my_words.dict.yaml | 词库配置，包含雾凇拼音的词库 |
| luna_pinyin_simp.custom.yaml   | 输入法的模糊音之类的配置     |
| squirrel.custom.yaml           | Mac 的输入法皮肤             |

## 皮肤
- 如果你喜欢折腾
  - https://github.com/fkxxyz/ssfconv
- 在 mac 中的参考很多，例如:
  - [简单安利 Rime 输入法](https://www.manjusaka.blog/posts/2020/01/28/simple-config-for-rime-input/#more)


## nixos 的配置
其他的内容都相同，就是 fcitx 和 rime 的安装和一般的系统不同。

```nix
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx.engines = with pkgs.fcitx-engines; [ rime ];
    fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
    ];
  };
```

参考 [NixOS 中文字体输入法](https://zhuanlan.zhihu.com/p/463403799) 配置。

## 参考 && TODO
- [双拼練習](https://github.com/BlueSky-07/Shuang)
- [GNU/Linux 输入法折腾笔记 (RIME)](https://mogeko.me/posts/zh-cn/031/)
- [](https://sspai.com/post/63916)
- [Arch Linux 下给 RIME 中](https://anclark.github.io/2020/11/23/Struggle_with_Linux/%E7%BB%99RIME%E4%B8%AD%E5%B7%9E%E9%9F%B5%E6%B7%BB%E5%8A%A0%E8%AF%8D%E5%BA%93/)
- [Rime 导入搜狗词库](https://www.jianshu.com/p/300bbe1602d4)
  - [”深蓝词库转换“ 一款开源免费的输入法词库转换程序](https://github.com/studyzy/imewlconverter)

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
