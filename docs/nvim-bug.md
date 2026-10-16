## .h 默认启用的是 cpp ，但是 cpp 中没有 once

- https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/c/c.json
- https://www.reddit.com/r/neovim/comments/13yw98e/how_can_i_switch_the_local_input_method_in_vim_on/

## [ ] 此外，struct-> 补全的时候，会出现在第一个字母上

- 是 ccls 的问题吗?

## lua 的格式化总是修改大片的代码

## nvim-cmp 补全时报 Invalid 'start_row': out of range

2026-09-29，在 Neovim 0.12.3 / nvim-cmp `2ffe79f1` 上复现：

1. 在文件最后一行输入文字，等待补全菜单出现。
2. 用 `<C-u>` 删除已输入文字，再用退格与上一行合并。
3. 候选菜单仍然显示，按回车确认时，`core.lua:403` 报错，且可能重复插入文字。

[上游 #2219](https://github.com/hrsh7th/nvim-cmp/pull/2219)
限制了 `TextChangedI` / `TextChangedP` 的处理，删除或合并行后候选未正确失效，
确认时仍使用旧行号。仅加载 nvim-cmp 也能复现，与保存或其他补全源无关。

目前在 `nvim/lua/usr/lazy.lua` 和 `nvim/lazy-lock.json` 中固定到前一个提交
`7d850f3daf38462c4760adae9cfdbd3417bbc01c`。相同步骤下菜单正确关闭，回车正常换行。
待上游修复并通过上述步骤验证后，再移除版本固定。
