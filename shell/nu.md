# 如何彻底征服 bash

bash 让人又爱又恨！
- 爱: 简洁。
- 恨: 太简洁。

在批处理作业上，bash 的简洁毋庸置疑，因为其本身定位就是各种现成工具的胶水，@todo 列举一下使用 bash 的大型项目。
但是 bash 的怪癖之处实在是太多了，难以记忆，难以理解。

stackoverflow 是有一个问题: [如何将 string 拆分为数组](https://stackoverflow.com/questions/10586153/how-to-split-a-string-into-an-array-in-bash)，
看完各个回答之后，我的感受就是为什么要设计的这么复杂。

使用 zsh 很多年了，但是替换
[oh my zsh](https://github.com/ohmyzsh/ohmyzsh)，我强烈推荐使用 zsh


## 各种工具也非常难
[modern unix](https://github.com/ibraheemdev/modern-unix) 的项目也是总结了一大堆。

- https://github.com/agarrharr/awesome-cli-apps
- https://github.com/alebcay/awesome-shell

## 思想上要重视
bash 不是一个可以随便用用就可以掌握的东西。

## 写 bash 容易出错

## bash 的语法和大家常用的语言差别太大了

## 很多简单的
1. 浮点加减

## 其他的替代项目
实际上，不过谢天
https://github.com/xonsh/xonsh


最近注意到了 nushell ，然后大约花费了两三个小时将以前的 oh-my-zsh 脚本切换过来，现在总结下这些年在

https://news.ycombinator.com/item?id=34588340

开发环境搭建:
- https://github.com/LhKipp/nvim-nu

## 问题
1. 没有 linter 将静态检查集成到 nvim 中
2. && || 之后被 and 和 or 替代才对
3. 自动补全中，man 无法处理

4. () 的文档找到一下

## 差别
1. && 被 ; 替代
  - https://github.com/nushell/nushell/issues/4139
2. 获取命令的输出 () 而不是 $()

	print $"(ls)" -- 这个会执行 ls 命令的
	print $"($command)" -- 这个才是
	print $"$command" -- 输出 $command
	print "($command)"
	print "$command"


```sh
	 $"username : (git config user.name)"
	 $"email : (git config user.email)"
```

## 可以提的问题
zoxide 的初始化脚本有问题

## 常见问题
- string : $"$(name)"
  - 小括号存在特殊含义的

> It's easy to pipe text-speaking tools into Nu pipelines, and there's a built-in `lines` command that will split line-break-delimited text into a list of strings.


- bash 的替代品: https://github.com/oilshell/oil/wiki/Alternative-Shells

真的见过无数个 bash 最佳实践的文章，说实话，为什么一个语言如此放纵非最佳实践。

## shellcheck 让我必须将所有的变量全部使用双引号包含进来
- http://www.oilshell.org/release/latest/doc/idioms.html#new-long-flags-on-the-read-builtin

## glob 中和字符串当时是使用的正则表达式吧

1. glob 中是否支持 [a,b]*
2. glob 只能处理文件是吗？

## 任何时候都不要使用 [
https://stackoverflow.com/questions/3427872/whats-the-difference-between-and-in-bash

## let 的赋值似乎让代码非常难以理解了

```nu
let name = []
for n in $database {
  # $name | append $n.name
  # echo $n.name
  name = ($name | prepend $n.name)
}
```

## 没有 format，没有 shellcheck ，好难受
- [ ] 不能贴着函数名字

## 为什么 module 不可以使用啊
比如这个官方的例子:
```nu
module commands {
    def animals [] {
        ["cat", "dog", "eel" ]
    }

    export def my-command [animal: string@animals] {
        print $animal
    }
}
```

## 如何实现多级命令的 switch
- 例如 sx switch how-to-go
