# 如何战胜 bash


为什么是"战胜"而不是"学会" bash ，我们先来学几个 bash 基本语法。

1. 非常相似的语法？
2. 这也可以，那也可以
3. 和主流出入过大
4. 默认行为不可控

应该很少人使用 bash 来写大型系统，但是我发现即使是写几百行的小项目，也非常痛苦。

[官方文档](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html) 几乎没有什么意义

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

## 无法理解
### 为什么 subcommand 是可以无视 set -e 的
```sh
set -e
function b() {
  cat g
  cat g
  cat g
  cat g
  cat g
}

function a() {
  cat g || true

  b # 如果直接调用 b ，那么 b 中第一个就失败
  a=$(b) # 但是如果是这种调用方法，b 中失败可以继续
}

a
```

## 关键参考
- https://mywiki.wooledge.org/BashFAQ
- http://mywiki.wooledge.org/BashPitfalls

[^1]: [glob](https://mywiki.wooledge.org/glob)
