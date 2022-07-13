# MAC 上的痛苦面具问题解决

对于 ARM 还是不错的。

吐槽一下，虽然有很多提升，但是
- 合上盖子，必须插上电源

<!-- - TMP_TODO -->
- workspace 的切换
- bash 版本过低，似乎必须使用 homebrew 中的 bash https://github.com/jitterbit/get-changed-files/issues/15
  - 使用这个方法切换: https://johndjameson.com/blog/updating-your-shell-with-homebrew

- Python 暂时无法索引，即使是增加了这个到 coc-setting.json 中间:
  - "python.pythonPath" : "/opt/homebrew/bin/python3"
