# 如何彻底征服 bash script

![](https://preview.redd.it/8a7tpszpdgj41.png?width=640&height=360&crop=smart&auto=webp&s=04e05726a9bb67ff47a8599101931409953859a0)

## 我很忙，不想听这么多废话


## 背景
大一升大二的暑假中，一个大佬帮我安装了 Linux，之后的几周时间逐渐熟悉并喜欢上了 shell 的使用，
但是我最近发现自己的对于 shell 下水平还是停留在那个暑假，干什么都需要 stackoverflow 一下，
一个问题总是在重复的查询，写一个 100 行的 bash script 需要一个上午。这种状况真的让人暴跳如雷。

我的之前的对于 bash 错误认识:
1. bash 不重要。人的手动操作是不可靠的，不可复现的，难以快速复制给其他人的，对于大多数人来说，批处理脚本非常重要，尤其是你打算写几十年的代码的时候。
2. bash 自然而然就会掌握，无需额外的花时间掌握。至少对于我来说，不是，必须刻意学习才可以。
3. 不要使用 Python C 语言和 bash 类比。

## bash script 的设计思想
对于 shell 编程，大致可以分为两个部分:
- 具体的工具，例如 git ipcs 之类的
- bash script

一个工具做好一件事情，而 bash 将工具粘合起来，高效的完成各种事情。

bash 的设计思想:
-  bash 处理的是各种命令的组合，而且需要足够简洁
  - 命令的输入输出都是 string
    - bash 中几乎没有数据类型，任何内容都是 string
    - 对于数值需要特殊的语法和命令
      - `[[ -eq ]]`，`$(())` 以及 `bc`
  - bash 将字符串处理的工作都交给 awk, sed，grep 和 cut 了
- bash 需要足够简洁
  - 利用 pipe
  - 没有异常处理
  - 没有面向对象
  - 没有结构体
  - 数据结构支持优先，只有 array 和 associated array
  - 使用了大量的缩写，例如 !! !$ $!

bash 没有设计出来过多的错误防护机制，几乎没什么人用 bash 写打项目。

## bash 奇怪的地方
局部变量 : 只有函数中的局部变量，但是没有 for 循环中的局部变量

## bash 设计失误
也许是我理解不到位

1. bash 使用 = 来作为相等判断，这导致bash 的赋值 `=` 两侧不能有空格。

## 1. 打好基础
[Bash 脚本教程](https://wangdoc.com/bash/index.html)

## 问题
1. pstree -p

注意到你可以控制每行参数个数（-L）和最大并行数（-P）

最有用的大概就是 !$， 它用于指代上次键入的参数，而 !! 可以指代上次键入的命令了

## [ ] http://mywiki.wooledge.org/BashPitfalls

1. Filenames with leading dashes
  - cp -- "$file" "$target" : 使用 -- 来处理

2. 不可以同时打开和重定向同一个文件
  - cat file | sed s/foo/bar/ > file ：这个会导致 file 中的内容为空，最简单的是使用一个中间符号来代替。

3. & 本身就是一个结束符号
  - `for i in {1..10}; do ./something &; done` : 将 & 后的 ; 去掉

@todo 从这里继续吧
```txt
34. if [[ $foo = $bar ]] (depending on intent)
```

## [ ] https://mywiki.wooledge.org/BashFAQ

## echo 的额外用法
1. -n 参数可以取消末尾的回车符
2. -e 参数会解释引号（双引号和单引号）里面的特殊字符（比如换行符\n

## 如何输出一个字符串
在 bash 中 \ 会让下一行和上一行放到一起来解释，体会一下下面的两个命令的差别:
```sh
echo "one two
            three"

echo "one two \
             three"

echo one two \
             three

echo one two
             three
```

- https://stackoverflow.com/questions/13335516/how-to-determine-whether-a-string-contains-newlines-by-using-the-grep-command

## 变量
- [indirect expansion](https://unix.stackexchange.com/questions/41292/variable-substitution-with-an-exclamation-mark-in-bash)
```sh
hello_world="value"
# Create the variable name.
var="world"
ref="hello_$var"
# Print the value of the variable name stored in 'hello_$var'.
printf '%s\n' "${!ref}"
```

```sh
var="world"
declare "hello_$var=value"
printf '%s\n' "$hello_world"
```

## 有用的变量

## 一个括号是不是足够逆天
https://unix.stackexchange.com/questions/306111/what-is-the-difference-between-the-bash-operators-vs-vs-vs

## eval 和 exec 的区别
https://unix.stackexchange.com/questions/296838/whats-the-difference-between-eval-and-exec/296852

功能都非常变态:
- eval 相当于执行这个字符串
- exec 将当前的 bash 替换为执行程序

## 常用工具

### awk
### pushd 和 popd
- https://unix.stackexchange.com/questions/77077/how-do-i-use-pushd-and-popd-commands

- 从左边进入
- 最左边的就是当前的目录
- pushd x 会进入到 x 中

在 zsh 中，是自动打开 `setopt autopushd`
https://serverfault.com/questions/35312/unable-to-understand-the-benefit-of-zshs-autopushd 的，
这导致 cd 的行为和 pushd 相同。


### [ ] https://effective-shell.com/part-2-core-skills/job-control/

## 一些资源
- [forgit](https://github.com/wfxr/forgit) A utility tool powered by fzf for using git interactively
- [Bash web server](https://github.com/dzove855/Bash-web-server/) : 只有几百行的 web server 使用 bash 写的 :star:
- [Write a shell in C](https://brennan.io/2015/01/16/write-a-shell-in-c/) : 自己动手写一个 shell
- [Pure bash bible](https://github.com/dylanaraps/pure-bash-bible)

## 一些博客
- [window powershell 和 bash 的对比](https://vedipen.com/2020/linux-bash-vs-windows-powershell/)

## shell 资源推荐
1. https://devhints.io/bash  : 语法清单
2. https://explainshell.com/ : 给出一个 shell 命令，对于其进行解释
3. https://wangchujiang.com/linux-command/
## 一些小技巧
- [alias](https://thorsten-hans.com/5-types-of-zsh-aliases)
- [自动回答交互式的 shell script](https://askubuntu.com/questions/338857/automatically-enter-input-in-command-line)

## zsh 的技巧
- take 创建并且进入目录
- ctrl-x e 进入编辑模式

## 一些库
- [gum](https://github.com/charmbracelet/gum)
- https://github.com/bats-core/bats-core : bash 测试框架

## 冷知识
- [locate vs find](https://unix.stackexchange.com/questions/60205/locate-vs-find-usage-pros-and-cons-of-each-other)
  - locate 只是比 find 更快而已
- 使用 mv /tmp/gafsdfa/fadafsdf{aaa,bb}.png 来实现 rename
- [根据 shell 启动的不同，加载的配置的文件不同](https://cjting.me/2020/08/16/shell-init-type/)
  - 存在 login 和 non-login ，interactive 和 non-interactive 之分
- [Shell 启动类型探究](https://cjting.me/2020/08/16/shell-init-type/) : 不错不错，讲解 bash 的启动

## 获取帮助
1. whatis
2. tldr
3. cheat.sh
4. apropos 模糊查询 man

## 有趣
- https://github.com/mydzor/bash2048/blob/master/bash2048.sh : 300 行的 2048


- 输入 top 10 的命令，但是没看懂
```sh
history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10
```

## shellcheck 也是有问题的
1. common.sh 可以解决一下吗？

## [ ] 整理一下 coprocess 的内容

## glob 中和字符串当时是使用的正则表达式吧

1. glob 中是否支持 [a,b]*
2. glob 只能处理文件是吗？
  3. 字符串比较的时候也是可以的

## 任何时候都不要使用 [
https://stackoverflow.com/questions/3427872/whats-the-difference-between-and-in-bash

## 整理下如下内容
- bash 的替代品: https://github.com/oilshell/oil/wiki/Alternative-Shells

真的见过无数个 bash 最佳实践的文章，说实话，为什么一个语言如此放纵非最佳实践。

## shellcheck 让我必须将所有的变量全部使用双引号包含进来
- http://www.oilshell.org/release/latest/doc/idioms.html#new-long-flags-on-the-read-builtin

## 迷茫啊，这个会因为双引号警告的
```txt
	if [[ ! $i =~ ".*debug.*" ]]; then
		rpm_extract $i
	fi
```

## 高级话题
### 如何理解这个
```sh
bash <(curl -L zellij.dev/launch) 这个命令如何理解？
```

## grep 和 egrep 的差别
- https://stackoverflow.com/questions/18058875/difference-between-egrep-and-grep
  - [ ]  对于 regex 的理解又成为了问题。
- https://unix.stackexchange.com/questions/17949/what-is-the-difference-between-grep-egrep-and-fgrep
  - 还有 fgrep

## 等于号叫我再次做人
```c
if ! [[ $number =~ $re ]] ; then
  echo "not a number"
fi
```
可以写成这个吗？
```c
if [[ ! $number =~ $re ]] ; then
  echo "not a number"
fi
```

多个链接到一起，如何
```c
if [[ ! $number =~ $re ]] ; then
  echo "not a number"
fi
```

## 整理一下:
  - 为什么这里必须存在一个双引号！

## 实际上，我们发现 bash 的一个 philosophy
- 很多常用命令不是熟练使用，还是痛苦面具
  - https://dashdash.io/


## 一个 AWK 痛苦面具问题
```sh
set -E -e -u -o pipefail
grep vendor_id /proc/cpuinfo | awk 'NR==1{print $0; exit}'
grep flags /proc/cpuinfo | awk 'NR==1{print $0; exit}'
```
我发现第一个 awk 不会让 exit non-zero，而第二个会。


## 重点分析下 find 命令
### 如何 flatten 一个目录
- https://unix.stackexchange.com/questions/52814/flattening-a-nested-directory
- find . -type f -exec ls '{}' +
  - 所有的参数一次执行
- find . -type f -exec ls '{}' \;
  - 对于每一个文件，分别 fork 出来执行
- find . -type f -execdir ls '{}' +
  - 切换到对应的目录执行

```txt
       -exec command ;
              Execute command; true if 0 status is returned.  All following arguments to find are taken to be arguments  to
              the  command  until an argument consisting of `;' is encountered.  The string `{}' is replaced by the current
              file name being processed everywhere it occurs in the arguments to the command, not just in  arguments  where
              it  is alone, as in some versions of find.  Both of these constructions might need to be escaped (with a `\')
              or quoted to protect them from expansion by the shell.  See the EXAMPLES section for examples of the  use  of
              the  -exec  option.  The specified command is run once for each matched file.  The command is executed in the
              starting directory.  There are unavoidable security problems surrounding use of the -exec action; you  should
              use the -execdir option instead.

       -exec command {} +
              This  variant  of  the -exec action runs the specified command on the selected files, but the command line is
              built by appending each selected file name at the end; the total number of invocations of the command will be
              much less than the number of matched files.  The command line is built in much the same way that xargs builds
              its command lines.  Only one instance of `{}' is allowed within the command, and it must appear at  the  end,
              immediately  before  the `+'; it needs to be escaped (with a `\') or quoted to protect it from interpretation
              by the shell.  The command is executed in the starting directory.  If any invocation with the  `+'  form  re‐
              turns  a  non-zero value as exit status, then find returns a non-zero exit status.  If find encounters an er‐
              ror, this can sometimes cause an immediate exit, so some pending commands may not be run at  all.   For  this
              reason  -exec my-command ... {} + -quit  may  not  result  in my-command actually being run.  This variant of
              -exec always returns true.
```

## 神奇的双引号
如果是在 ${} 和 $() 中，是可以继续使用双引号的

## https://stackoverflow.com/questions/7442417/how-to-sort-an-array-in-bash

## dirname 和 basename

## 文件处理

了解如何使用 sort 和 uniq，包括 uniq 的 -u 参数和 -d 参数，具体内容在后文单行脚本节中。另外可以了解一下 comm。

了解如何使用 cut，paste 和 join 来更改文件。很多人都会使用 cut，但遗忘了 join。

了解如何运用 wc 去计算新行数（-l），字符数（-m），单词数（-w）以及字节数（-c）。

了解 sort 的参数。显示数字时，使用 -n 或者 -h 来显示更易读的数（例如 du -h 的输出）。明白排序时关键字的工作原理（-t 和 -k）。例如，注意到你需要 -k1，1 来仅按第一个域来排序，而 -k1 意味着按整行排序。稳定排序（sort -s）在某些情况下很有用。例如，以第二个域为主关键字，第一个域为次关键字进行排序，你可以使用 sort -k1，1 | sort -s -k2，2。

## awk

      awk '{ x += $3 } END { print x }' myfile

      egrep -o 'acct_id=[0-9]+' access.log | cut -d= -f2 | sort | uniq -c | sort -rn

## 总结 job control
- hohup command &
- fg
- bg

## ~ 和 $HOME 的区别
https://askubuntu.com/questions/1177464/difference-between-home-and

- $HOME is an environment variable
- ~ is a shell expansion symbol

让我们回忆一下:

> 这种特殊字符的扩展，称为模式扩展（globbing）。其中有些用到通配符，又称为通配符扩展（wildcard expansion）。Bash 一共提供八种扩展。

启动第一个扩展就是波浪线扩展。

所以，区别就是:
arg_virtio="-drive aio=native,,file=~/hack/iso/virtio-win-0.1.208.iso,media=cdrom,index=2"
中的 ~ 是无法被展开的。

所以，你不能在 C 语言中使用
```c
int fd = open("~/abc.txt", O_RDWR | O_CREAT, 0644);
```

## bash 一个复杂的原因

有些功能是 bash 内置的，
但是外部工具也可以做的。

例如: https://stackoverflow.com/questions/13210880/replace-one-substring-for-another-string-in-shell-script

但是，实际上，也可以用 sed

## https://github.com/johnkerl/miller

## subshell

```txt
COMMAND EXECUTION ENVIRONMENT
       The shell has an execution environment, which consists of the following:

       •      open files inherited by the shell at invocation, as modified by redirections supplied to the exec builtin

       •      the current working directory as set by cd, pushd, or popd, or inherited by the shell at invocation

       •      the file creation mode mask as set by umask or inherited from the shell's parent

       •      current traps set by trap

       •      shell parameters that are set by variable assignment or with set or inherited from the shell's parent in the environment

       •      shell functions defined during execution or inherited from the shell's parent in the environment

       •      options enabled at invocation (either by default or with command-line arguments) or by set

       •      options enabled by shopt

       •      shell aliases defined with alias

       •      various process IDs, including those of background jobs, the value of $$, and the value of PPID

       When a simple command other than a builtin or shell function is to be executed, it is invoked in a separate execution environment that consists of the following.  Unless otherwise noted, the values are inherited from the shell.

       •      the shell's open files, plus any modifications and additions specified by redirections to the command

       •      the current working directory

       •      the file creation mode mask

       •      shell variables and functions marked for export, along with variables exported for the command, passed in the environment

       •      traps caught by the shell are reset to the values inherited from the shell's parent, and traps ignored by the shell are ignored

       A command invoked in this separate environment cannot affect the shell's execution environment.

       Command  substitution,  commands  grouped with parentheses, and asynchronous commands are invoked in a subshell environment that is a duplicate of the shell environment, except that traps caught by the shell are reset to the values that the
       shell inherited from its parent at invocation.  Builtin commands that are invoked as part of a pipeline are also executed in a subshell environment.  Changes made to the subshell environment cannot affect the shell's execution environment.

       Subshells spawned to execute command substitutions inherit the value of the -e option from the parent shell.  When not in posix mode, bash clears the -e option in such subshells.

       If a command is followed by a & and job control is not active, the default standard input for the command is the empty file /dev/null.  Otherwise, the invoked command inherits the file descriptors of the calling shell as modified  by  redi‐
       rections.

```

```sh
set -e
function b() {
  cat /abc
  cat /abc
}

function a() {
  cat abc || true

  b # 如果直接调用 b ，那么 b 中第一个就失败
  a=$(b) # 但是如果是这种调用方法，b 中失败可以继续
}

a
```
## 看看这个
https://www.panix.com/~elflord/unix/grep.html#why

## 一个符号，多种场景语义不同的

https://unix.stackexchange.com/questions/47584/in-a-bash-script-using-the-conditional-or-in-an-if-statement

```txt
if [ "$fname" = "a.txt" ] || [ "$fname" = "c.txt" ]
```

但是 `ls a || ls` 中的 `||` 则是表示第一个命令失败，那么执行第二个。


## bash 中没有 bool
但是存在 true 和 false command

但是 a=true 这个时候 true 是 string 而已
https://stackoverflow.com/questions/2953646/how-can-i-declare-and-use-boolean-variables-in-a-shell-script


## glob 自动失败的是偶

```sh
QEMU_PID_DIR="/var/run/libvirt/qemu"

for i in "$QEMU_PID_DIR"/*.pid; do
  echo $i
done
```
如果一个文件都没有，echo $i 得到
/var/run/libvirt/qemu/*.pid


## glob 语法和 regex 的差别让人真的很烦
```sh
disk=nvme0n1
disk=${disk%%[0-9]*}
echo $disk # 得到的居然是 nvme ，因为 * 表示拼配任何字符
```

## TODO : nvim/snippets/sh.snippets 中的 note_cmpstring 需要重写下

## 看看这个 blog ，深入理解下 shell
https://a-wing.top/shell/2021/05/01/sh-compatibles-history : 一共三篇
