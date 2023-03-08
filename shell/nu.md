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
