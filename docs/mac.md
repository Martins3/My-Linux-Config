# MAC 上的痛苦面具问题解决

ARM 还是不错的。

吐槽一下，虽然有很多提升，但是
- 合上盖子，必须插上电源。
- 对于无线鼠标的支持非常差。
- 没有 sshfs，难以同步


<!-- - TMP_TODO -->
- workspace 的切换
- bash 版本过低，似乎必须使用 homebrew 中的 bash https://github.com/jitterbit/get-changed-files/issues/15
  - 使用这个方法切换: https://johndjameson.com/blog/updating-your-shell-with-homebrew

- Python 暂时无法索引，即使是增加了这个到 coc-setting.json 中间:
  - "python.pythonPath" : "/opt/homebrew/bin/python3"
- 不知道为什么，kitty 必须从 iterm 中启动
  - 应该是环境变量的问题，使用 open $(which kitty) 来测试

## 获取 ip addr

- 打开 https://superuser.com/questions/104929/how-do-you-run-a-ssh-server-on-mac-os-x
- https://www.hellotech.com/guide/for/how-to-find-ip-address-on-mac

