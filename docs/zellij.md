## zellij
- https://zellij.dev/documentation/introduction.html
- https://news.ycombinator.com/item?id=26902430
  - 大家的评价是，技术体系很新

启动一个新的布局:
zellij --layout /home/martins3/.dotfiles/config/zellij/docs.kdl

config/zellij/default.kdl 是默认的启动布局。

但是估计从 tmux 到 zellij 迁移难度比较大，需要完成如下工作：
- [ ] 快速切换 session
- [ ] 自动修改 tab 的名称
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
