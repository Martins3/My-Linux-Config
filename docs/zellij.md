## zellij
- https://zellij.dev/documentation/introduction.html
- https://news.ycombinator.com/item?id=26902430
  - 大家的评价是，技术体系很新

启动一个新的布局:
```bash
zellij --layout /home/martins3/.dotfiles/config/zellij/layout/docs.kdl
```

默认布局目录:
`/home/martins3/.dotfiles/config/zellij/layout`

配置文件:
`/home/martins3/.dotfiles/config/zellij/config.kdl`

## 当前配置常用入口

- `Ctrl h` 进入兼容 tmux 的前缀模式
- `Ctrl h p` 进入 pane mode
- `Ctrl h t` 进入 tab mode
- `Ctrl h o` 进入 session mode
- `Ctrl g` 显示或隐藏 floating panes
- `Ctrl s` 用 `nvim` 打开当前 pane 的 scrollback
- `Alt [` / `Alt ]` 切换 swap layout
- `Alt h/j/k/l` 在 pane 间移动焦点，左右撞到边界时会切 tab

`pane/tab/session` 模式里按 `Esc` 或 `Enter` 返回 normal mode。

## 这次补上的高级特性

### 1. Stacked pane
- `Ctrl h` 然后按 `s`

效果:

- 在当前 tab 里创建一个 stacked pane
- 适合在同一块区域叠多个任务，比如 `htop`、日志、测试输出

配合使用:

- `Alt +` / `Alt -` 调整大小
- `Tab` 或 `o` 切换到下一个 pane
- `z` 全屏当前 pane

### 2. Pin floating pane

前置:

- 先把 pane 变成浮动 pane
- 可以用 `Ctrl g` 打开 floating 层
- 或者 `Ctrl h` 然后按 `e`，把当前 pane 在 embed / floating 间切换

然后:

- `Ctrl p` 然后按 `i`
- 或者 `Ctrl h` 然后按 `i`

效果:

- 把当前 floating pane pin 住
- 很适合固定一个小日志窗、监控窗、临时 REPL

### 3. Sync Input

两种用法:

- `Ctrl t` 然后按 `s`
- `Ctrl h` 然后按 `S`

效果:

- 当前 tab 里的 pane 同时接收输入
- 再按一次就是关闭

适合场景:

- 多个远程机器执行同一条命令
- 多个目录同时跑同构操作

### 5. Pane Grouping

- `Alt Shift p` 开关 group marking
- `Alt p` 把当前 pane 加入或移出分组

这个功能和 `advanced_mouse_actions true` 配合更自然，适合批量组织一组 pane。

### 6. Session / Layout / Plugin 管理界面

先按 `Ctrl o` 进入 session mode，然后:

- `w` 打开 session manager
- `l` 打开 layout manager
- `p` 打开 plugin manager
- `c` 打开 configuration
- `a` 打开 about
- `s` 打开 share 面板
- `d` detach 当前 session

这些界面都会以 floating plugin 的形式打开。

## 这份配置里我显式打开的行为

- `stacked_resize true`
  - resize 太小时允许 pane 进入 stacked 形态
- `advanced_mouse_actions true`
  - 开启更完整的鼠标 hover / pane grouping 交互

## 备注

- `Ctrl p` / `Ctrl t` / `Ctrl o` 是这次补回来的原生 mode 入口，你原来那组 `pane { ... }` 绑定现在终于能直接用了。
- 你的 layout 目录已经是 `config/zellij/layout`，之后新增布局就放这里。

## 还没做的事

但是估计从 tmux 到 zellij 迁移难度比较大，需要完成如下工作：
- [ ] 快速切换 session
- [ ] 使用 ctrl+shift+arrow 移动 tab
- [ ] 为什么当一个 layout 含有:
```txt
    pane size=1 borderless=true {
      plugin location="zellij:tab-bar"
    }
```
nvim 的启动首先会卡住一下，是谁的问题

- [x] https://github.com/zellij-org/zellij/issues/1760 这个问题没有解决
  - 打开屏幕的一堆横线，但是很快就被解决了
  - [ ] 在 nvim 打开的一瞬间，还是存在很多横线
- [ ] 屏幕切换的时候，中文显示有问题。
  - 这个问题类似: https://github.com/zellij-org/zellij/issues/2256
- [ ] [无法使用鼠标调整 pane 的大小。](https://github.com/zellij-org/zellij/issues/1262)
- [ ] Alt + hjkl 会直接移动到下一个 tab 中去

问题很多，没有时间一个个的修复了，偶尔用用。

真的是相当酷炫啊
https://zellij.dev/news/new-plugin-system/

只要这个项目不死掉，完全可以切换过去。
