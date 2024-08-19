# Rime 输入法

我使用 Rime 输入法并不是其各种高级功能，我之前一直使用搜狗，但是有一次搜狗崩溃了，
然后又不知道恢复，在网上参考了各种资料，都无法解决。
1. https://askubuntu.com/questions/1251749/how-to-install-sogou-input-method-on-ubuntu-20-04
2. https://leimao.github.io/blog/Ubuntu-Gaming-Chinese-Input/
忍无可忍，就换成 Rime 了。但是我发现 Rime 的输入法的门槛很高，这里简单记录下配置过程。

## 安装

参考 rime/linux-install.sh ，其实也就是:

首先在你对应的系统中安装 fcitx-rime，例如:
- fedora : https://fedoraproject.org/wiki/I18N/Fcitx5
```sh
sudo dnf install -y fcitx5-rime
```

- 安装 : [rime](https://github.com/fcitx/fcitx-rime)
- 安装并且使用: [plum](https://github.com/rime/plum)
- 从 [雾凇拼音](https://github.com/iDvel/rime-ice) 中增加词库，雾凇拼音其他的配置一时无法全部消化吸收，仅仅拷贝其中的 cn_dicts 来扩充自己的词库。

## 配置 fcitx5
在 Fcitx5 Configure 中增加 rime 输入法。

在 "Available Input Method" 中搜索 Rime，选中之后，点击中间的那个 "<"，让 "Current Input Method" 中增加 Rime 。

![image](https://github.com/Martins3/My-Linux-Config/assets/16731244/4c0efdd4-d913-4f03-8cd1-c1a7884b06b1)


## 常用快捷键
1. `ctrl space` 唤出 rime 输入法
2. shift 切换的 rime 的中文输入和英文输入。
3. `ctrl delete` : 删除自造词

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


https://github.com/fcitx/fcitx5-rime/issues/15

## nixos 的配置
其他的内容都相同，就是 fcitx 和 rime 的安装和一般的系统不同。

```nix
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
    ];
  };
```

参考 [NixOS 中文字体输入法](https://zhuanlan.zhihu.com/p/463403799) 配置。

## 2024-05-30 的发现
如果似乎是需要将 fcitx 的配置中的 Shift-L 取消掉，不然他会覆盖掉 rime 的行为。

甚至怀疑是键盘的问题，但是实际上并不是；
https://superuser.com/questions/248517/show-keys-pressed-in-linux

似乎自定义的输入法没办法用了。 例如:
rime/luna_pinyin.martins3.dict.yaml

## rime-ls
```sh
git clone https://github.com/wlh320/rime-ls
sudo dnf install librime-devel
cd rime-ls
cargo build --release
cp target/release/rime_ls ~/.cargo/bin
```
在 asahi linux  fedora 上尝试的时候，还需要安装如下内容:

这是没有图形界面的哦，一样是可以正常使用的
```sh
/home/martins3/.dotfiles/rime/linux-install.sh
sudo dnf install ibus-rime
```

### 存在的问题
1. 自动选择数值
  - 没太搞懂，虽然说，https://github.com/liubianshi/cmp-lsp-rimels 已经解决了，但是实际上不好用，但是问题不大，因为
2. , 的输入应该是自动，谁 miaomiao  的输入中文的忽然携带一个英文都好
3. 是否可以变为 toggle 的模式
4. 没办法切换为双拼，但是在 rime-ls 中是可以的
```txt
  schema_trigger_character = "&" -- [since v0.2.0] 当输入此字符串时请求补全会触发 “方案选单”
```
5. 双拼没办法显示当自动匹配的拼音字母

## 小鹤双拼的配置

- https://github.com/brglng/rime-xhup
- https://github.com/ASC8384/myRime

配置小鹤双拼还是比较简单的。

- https://www.zhihu.com/question/20698750

![](https://pica.zhimg.com/v2-8d8018a2e277a8b9c2e3ba4baa2a3632_r.jpg?source=1def8aca)

- [ ] 如何将 emoji 去掉?


不能在赞同了: https://www.zhihu.com/question/383416202/answer/2584564433

## 使用 rime-ice 加上 rime-auto-deploy

https://github.com/iDvel/rime-ice
https://github.com/Mark24Code/rime-auto-deploy

直接无敌!

- [ ] 这个基础上处理下模糊音
- [ ] 默认上屏的操作
- [ ] 不要展示拼音


https://github.com/iDvel/rime-ice/issues/133
https://www.mintimate.cc/zh/guide/faQ.html#linux%E8%96%84%E8%8D%B7%E9%85%8D%E7%BD%AE%E6%97%A0%E6%B3%95%E4%BD%BF%E7%94%A8


实在是太复杂了，我靠 : 似乎这里没有插件，所以有问题
https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/development/libraries/librime/default.nix

## 切换 ibus 和 fcitx5

似乎 fcitx5 很简单：

https://github.com/fcitx/fcitx5-rime
https://github.com/rime/ibus-rime/issues : 这个不维护了

## rimels 初步尝试
```diff
diff --git a/nvim/lua/usr/lazy.lua b/nvim/lua/usr/lazy.lua
index f49b0c7ef8a1..d1459b277c94 100644
--- a/nvim/lua/usr/lazy.lua
+++ b/nvim/lua/usr/lazy.lua
@@ -185,63 +185,4 @@ require("lazy").setup({
     config = true,
   },
   'ojroques/nvim-osc52',
-  {
-    "liubianshi/cmp-lsp-rimels",
-    dir = "/home/martins3/core/cmp-lsp-rimels",
-    -- 这个插件让正常的补全很卡
-    enabled = false,
-    config = function()
-      local compare = require("cmp.config.compare")
-      local cmp = require("cmp")
-      cmp.setup({
-        -- 设置排序顺序
-        sorting = {
-          comparators = {
-            compare.sort_text,
-            compare.offset,
-            compare.exact,
-            compare.score,
-            compare.recently_used,
-            compare.kind,
-            compare.length,
-            compare.order,
-          },
-        },
-      })
-
-      require("rimels").setup({
-        keys = { start = "jk", stop = "jh", esc = ";j", undo = ";u" },
-        cmd = { "/home/martins3/.cargo/bin/rime_ls" },
-        rime_user_dir = "/home/martins3/.local/share/rime-ls",
-        shared_data_dir = "/home/martins3/.local/share/fcitx5/rime",
-        filetypes = { "NO_DEFAULT_FILETYPES" },
-        single_file_support = true,
-        settings = {},
-        docs = {
-          description = [[https://www.github.com/wlh320/rime-ls, A language server for librime]],
-        },
-        max_candidates = 9,
-        trigger_characters = {},
-        schema_trigger_character = "&", -- [since v0.2.0] 当输入此字符串时请求补全会触发 “方案选单”
-        probes = {
-          ignore = {},
-          using = {},
-          add = {},
-        },
-        detectors = {
-          with_treesitter = {},
-          with_syntax = {},
-        },
-        cmp_keymaps = {
-          disable = {
-            space = false,
-            numbers = false,
-            enter = false,
-            brackets = false,
-            backspace = false,
-          },
-        },
-      })
-    end,
-  },
 }, {})
```

## 参考 && TODO
- [双拼練習](https://github.com/BlueSky-07/Shuang)
- [GNU/Linux 输入法折腾笔记 (RIME)](https://mogeko.me/posts/zh-cn/031/)
- [小狼毫 3 分钟入门及进阶指南](https://sspai.com/post/63916)
- [Arch Linux 下给 RIME 中](https://anclark.github.io/2020/11/23/Struggle_with_Linux/%E7%BB%99RIME%E4%B8%AD%E5%B7%9E%E9%9F%B5%E6%B7%BB%E5%8A%A0%E8%AF%8D%E5%BA%93/)
- [Rime 导入搜狗词库](https://www.jianshu.com/p/300bbe1602d4)
  - [”深蓝词库转换“ 一款开源免费的输入法词库转换程序](https://github.com/studyzy/imewlconverter)
- [也致第一次安装 Rime 的你](https://gitlab.com/xianghongai/Rime/-/tree/main)
- [ssnhd 的 rime 教程](https://github.com/ssnhd/rime)

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
