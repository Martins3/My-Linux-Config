## 问题
1. 没有 linter 将静态检查集成到 nvim 中
2. && || 之后被 and 和 or 替代才对
3. 自动补全中，man 无法处理
4. () 的文档找到一下

## 差别
1. 没有 &&，任何错误都是导致返回，如果想要容忍，增加 nu
  - https://github.com/nushell/nushell/issues/4139
2. 获取命令的输出 () 而不是 $()

	print $"(ls)" -- 这个会执行 ls 命令的
	print $"($command)" -- 这个才是
	print $"$command" -- 输出 $command
	print "($command)"
	print "$command"

```nu
	 $"username : (git config user.name)"
	 $"email : (git config user.email)"
```

## 可以提的问题
zoxide 的初始化脚本有问题

## 常见问题
- string : $"$(name)"
  - 小括号存在特殊含义的

> It's easy to pipe text-speaking tools into Nu pipelines, and there's a built-in `lines` command that will split line-break-delimited text into a list of strings.

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

## [ ] 为什么 module 不可以使用啊
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

## [ ]  如何实现多级命令的自动补全
- 例如 sx switch how-to-go

## 没有 switch

## record 获取数值
如果 record 的参数是一个下标，这个无法通过检查的
```c
$images.$i # 不可以
let image_name = ($images | select $i) # 不可以
```
## nu-check --debug 结果完全是错的

## parse 的正则完全无法理解
- https://www.nushell.sh/commands/docs/parse.html
- "a  b           c" 都无法轻易的处理
  - 还是得靠 awk


## 这个功能无法实现的特别丑
```c
make -j`nproc` bindeb-pkg
```
这就是 bash 的灵活之处。

## 这个命令无法支持

git am --keep-cr --signoff < ../b.diff

nushell 正则无法自动补全

## 内置的 mv 无法 move 多个成员
- mv a.diff a.sh b.diff `2023-3-14/` 这个代码是会报错的

## 内置的 ps 不知道如何替换回来

## kill -l 这个命令会出错

## 命令不存在的时候，zsh 下的提示更加科学

## ps 命令的替换，实在是太傲慢了
- ps 的复杂程度，不是他可以理解的
