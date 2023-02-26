# 从 zsh 到 nushell

https://news.ycombinator.com/item?id=34588340

开发环境搭建:
- https://github.com/LhKipp/nvim-nu

## 问题
1. 没有 linter 将静态检查集成到 nvim 中
2. && || 之后被 and 和 or 替代才对
3. 自动补全中，man 无法处理


## 差别
1. && 被 ; 替代
  - https://github.com/nushell/nushell/issues/4139
2. 获取命令的输出 () 而不是 $()

## 可以提的问题
zoxide 的初始化脚本有问题

## 常见问题
- string : $"$(name)"
  - 小括号存在特殊含义的

