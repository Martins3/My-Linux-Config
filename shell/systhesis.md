# 如何战胜 bash

为什么是"战胜"而不是"学会" bash ，我们先来学几个 bash 基本语法。

1. 非常相似的语法？
2. 这也可以，那也可以
3. 和主流出入过大
4. 默认行为不可控

应该很少人使用 bash 来写大型系统，但是我发现即使是写几百行的小项目，也非常痛苦。

## [ ] 命令和符号的区别

## if
比较字符串，数值 和 文件使用
```sh
if [[ "$a" == "$b" ]];then
  echo "same"
fi
```

静态类型系统中，一个比较符号可以在不同操作数下存在不同的含义，例如 `>` 可以表示数字大于，也可以表示字符串排序。
但是 bash 没有类型系统，需要使用不同的比较符来区分比较对象。

但是判断命令是否成功的标志的形式是:
```sh
if cat somefile; then
  echo "same"
fi
```

## 数值类型太弱了
仅仅支持整数，不然就是 awk 或者 bc
$((1 + 2))

还需要手动判断是不是整数:
is_uint() { case $1 in '' | *[!0-9]*) return 1 ;; esac }

## glob 和 regex
默认的 glob 的，几乎是任何地方都需要增加上双引号。

这两个不等价，因为 Bash also allows globs to appear on the right-hand side of a comparison inside a [[ command: [^1]

```txt
if [[ "$a" == "$b" ]];
if [[ $a == $b ]];
```

但是这两个等价，因为 `=~` 描述的正则:
```txt
if [[ $foo =~ "$bar" ]];
if [[ $foo =~ $bar ]];
```
虽然 glob 的

### intensionally glob

a=$(echo *.md)
echo "$a"

## 恐怖的双引号
在对于含有空格的可以采用双引号包围，但是 $var 的时候自动去掉双引号

可以使用这个成员:
```txt
var="cpu family"
grep "$var" /proc/cpuinfo # 这个没有问题，被展开为 grep 'cpu family' /proc/cpuinfo
grep $var /proc/cpuinfo # 这个有问题，被展开为 grep cpu family /proc/cpuinfo
```

## [ ] 居然还有好几个
shopt -s extglob nullglob globstar

[^1]: [glob](https://mywiki.wooledge.org/glob)
