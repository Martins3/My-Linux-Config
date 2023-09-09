# 如何战胜 bash


为什么是"战胜"而不是"学会" bash ，我们先来学几个 bash 基本语法。

1. 非常相似的语法？
2. 这也可以，那也可以
3. 和主流出入过大
4. 默认行为不可控


[官方文档](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html) 几乎没有什么意义

stackoverflow 是有一个问题: [如何将 string 拆分为数组](https://stackoverflow.com/questions/10586153/how-to-split-a-string-into-an-array-in-bash)，
看完各个回答之后，我的感受就是为什么要设计的这么复杂。

[oh my zsh](https://github.com/ohmyzsh/ohmyzsh)，我强烈推荐使用 zsh


## 各种工具也非常难
[modern unix](https://github.com/ibraheemdev/modern-unix) 的项目也是总结了一大堆。
- https://github.com/agarrharr/awesome-cli-apps
- https://github.com/alebcay/awesome-shell

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

### 如果你确实希望使用 regex ，但是又不想 bash 报错
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

## 关键参考
- https://mywiki.wooledge.org/BashFAQ
- http://mywiki.wooledge.org/BashPitfalls



## 方法

### 一个 template
其他的都比较容易理解，但是除了
[set -E ](https://stackoverflow.com/questions/64852814/in-bash-shell-e-option-explanation-what-does-any-trap-inherited-by-a-subshell)

1. shell functions
2. command substitutions
3. subshell

bash 在 subshell 中会去掉 set -e 的属性，但是可以 `inherit_errexit` 将

```txt
inherit_errexit
        If set, command substitution inherits the value of the errexit option, instead of unsetting it in the subshell environment.  This option is enabled when posix mode is enabled.
```

### 不要被 posix 分心

bash 才是标准，posix 不是!

bash 中的 --posix 也不用理会。

## 看看这个
https://www.micahlerner.com/2021/07/14/unix-shell-programming-the-next-50-years.html
https://medium.com/fundbox-engineering/cheating-at-a-company-group-activity-using-unix-tools-5c1d706f3d58
