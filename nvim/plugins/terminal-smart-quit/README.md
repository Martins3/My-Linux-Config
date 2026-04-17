# terminal-smart-quit.nvim

为什么是 qa ，那么 terminal 中内容直接被 kill 掉:

如 wqa ，发现如果 nvim 打开了 terminal ，无论是 ，如果执行 wqa 会有这个错误
```txt
E948: Job still running
E676: No matching autocommands for buftype= buffer
```
所以
terminal buffer 需要单独判断：

1. 停在 zsh 提示符时自动清理 terminal
2. 前台是其它程序时阻塞退出，避免误杀正在运行的任务

## Setup

```lua
require("terminal-smart-quit")
```

## Semantics

- If a terminal's controlling process is `zsh` and it still owns the tty foreground process group, the terminal is treated as an idle shell and will be closed automatically.
- If the tty foreground process group belongs to another program, quitting is blocked and a warning explains which terminal buffers are still busy.

