# 这一次我要学会 bash

基本参考 [Bash 脚本教程](https://wangdoc.com/bash/index.html)

![](https://preview.redd.it/8a7tpszpdgj41.png?width=640&height=360&crop=smart&auto=webp&s=04e05726a9bb67ff47a8599101931409953859a0)

## 问题
- 学会使用 dirname 和 basename
- [ ] [The art of command line](https://github.com/jlevy/the-art-of-command-line/blob/master/README-zh.md#%E4%BB%85%E9%99%90-os-x-%E7%B3%BB%E7%BB%9F)

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

## Bash 的基本语法

1. -n 参数可以取消末尾的回车符
2. -e 参数会解释引号（双引号和单引号）里面的特殊字符（比如换行符\n

在 bash 中 \ 会让下一行和上一行放到一起来解释，体会一下下面的两个命令的差别:
```sh
echo "one two
three"

echo "one two \
three"
```

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

## 数组
拷贝:
hobbies=( "${activities[@]}" )
增加一项:
hobbies=( "${activities[@]}" diving )
myIndexedArray+=('six')
用 unset 命令来从数组中删除一个元素：
unset -v 'fruits[0]'

## 有用的变量

- SECCOND :  记录除了给上一次到这一次的时间
- "${FUNCNAME[@]}" : 调用栈

## eval 和 exec 的区别
https://unix.stackexchange.com/questions/296838/whats-the-difference-between-eval-and-exec/296852

功能都非常变态:
- eval 相当于执行这个字符串
- exec 将当前的 bash 替换为执行程序

## 常用工具

### awk
基本参考这篇 [blog](https://earthly.dev/blog/awk-examples/)，其内容还是非常容易的。

- $0 是所有的参数
- $1  ... 是之后的逐个
```sh
echo "one two
three" | awk '{print $1}'

awk '{ print $1 }' /home/maritns3/core/vn/security-route.md
```

```sh
echo "one|two|three" | awk -F_ '{print $1}'
```

- $NF seems like an unusual name for printing the last column
- NR(number of records) 表示当前是第几行
- NF(number of fields) : 表示当前行一共存在多少个成员

```sh
echo "one_two_three" | awk -F_ '{print NR " " $(NF - 1) " " NF}'
```

awk 的正则匹配:
```sh
awk '/hello/ { print "This line contains hello", $0}'
awk '$4~/hello/ { print "This field contains hello", $4}'
awk '$4 == "hello" { print "This field is hello:", $4}'
```

awk 的 BEGIN 和 END 分别表示在开始之前执行的内容。

awk 还存在
- Associative Arrays
- for / if

### pushd 和 popd
- https://unix.stackexchange.com/questions/77077/how-do-i-use-pushd-and-popd-commands

- 从左边进入
- 最左边的就是当前的目录
- pushd x 会进入到 x 中

在 zsh 中，是自动打开 `setopt autopushd`
https://serverfault.com/questions/35312/unable-to-understand-the-benefit-of-zshs-autopushd 的，
这导致 cd 的行为和 pushd 相同。

### 提升 bash 安全的操作
- [ ] http://mywiki.wooledge.org/BashPitfalls

1. 使用 local
```sh
change_owner_of_file() {
    local filename=$1
    local user=$2
    local group=$3

    chown $user:$group $filename
}
```

```sh
temporary_files() {
    echo $FUNCNAME $@
}
```

### [ ] https://effective-shell.com/part-2-core-skills/job-control/

## 资源和工具
1. https://explainshell.com/
2. https://wangchujiang.com/linux-command/


## 一些资源
- [forgit](https://github.com/wfxr/forgit) A utility tool powered by fzf for using git interactively
- [Bash web server](https://github.com/dzove855/Bash-web-server/) : 只有几百行的 web server 使用 bash 写的 :star:
- [Write a shell in C](https://brennan.io/2015/01/16/write-a-shell-in-c/) : 自己动手写一个 shell
- [Pure bash bible](https://github.com/dylanaraps/pure-bash-bible)

## 一些博客
- [window powershell 和 bash 的对比](https://vedipen.com/2020/linux-bash-vs-windows-powershell/)

## 重定向
1. ls > /dev/null
2. ls 2> /dev/null
3. ls > /dev/null > 2>&1 或者 &> file
4. cat < file

https://wizardzines.com/comics/redirects/


`shell` 和 `gnu` `make`, `cmake` 等各种工具类似，一学就会，学完就忘。究其原因，是因为使用频率太低了。
所以，shell 我不建议非常认真系统的学习，因为学完之后发现根本用不上。难道你每天都需要使用正则表达式删除文件吗?

## shell 资源推荐
1. https://devhints.io/bash  : 语法清单
2. https://explainshell.com/ : 给出一个 shell 命令，对于其进行解释

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

## 获取帮助
1. whatis
2. tldr
3. cheat.sh
4. apropos 模糊查询 man

## 有趣
- https://github.com/mydzor/bash2048/blob/master/bash2048.sh : 300 行的 2048

## TODO
- https://cjting.me/2020/08/16/shell-init-type/ : 不错不错，讲解 bash 的启动

- 输入 top 10 的命令，但是没看懂
```sh
history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10
```

## shellcheck 也是有问题的
1. common.sh 可以解决一下吗？

## [ ] 整理一下 coprocess 的内容

## [ ] 整理一下 ${a:-1} 的操作

这个代码应该是不科学的吧
```txt
echo "${1-}"
echo "${2-}"

echo "${1}"
echo "${2}"
```

## glob 中和字符串当时是使用的正则表达式吧

1. glob 中是否支持 [a,b]*
2. glob 只能处理文件是吗？

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
### trap

### -E

测试了一下，还是完全无法理解:
```txt

-E      If  set,  any  trap  on  ERR is inherited by shell
                      functions, command substitutions, and commands ex‐
                      ecuted in a subshell environment.  The ERR trap is
                      normally not inherited in such cases.
```

### 如何理解这个
```sh
bash <(curl -L zellij.dev/launch) 这个命令如何理解？
```

## grep 和 egrep 的差别

## 经典作品，阅读一下 : https://github.com/jlevy/the-art-of-command-line/blob/master/README-zh.md

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
- https://stackoverflow.com/questions/13335516/how-to-determine-whether-a-string-contains-newlines-by-using-the-grep-command
  - 为什么这里必须存在一个双引号！

## 实际上，我们发现 bash 的一个 philosophy
- 很多常用命令不是熟练使用，还是痛苦面具
  - https://dashdash.io/

http://mywiki.wooledge.org/BashPitfalls 其实没必要，使用 shellcheck 即可

## 一个 AWK 痛苦面具问题
```sh
set -E -e -u -o pipefail
grep vendor_id /proc/cpuinfo | awk 'NR==1{print $0; exit}'
grep flags /proc/cpuinfo | awk 'NR==1{print $0; exit}'
```
我发现第一个 awk 不会让 exit non-zero，而第二个会。

## bash 中的 map
- https://stackoverflow.com/questions/1494178/how-to-define-hash-tables-in-bash
  - 使用 cpu-flags 来分析吧

## 全局变量和局部变量
- [ ] 如果想要清理

```sh
for num in "${!number[@]}"; do
	# flags=${number[$num]}

	declare -A os
	declare -A cpu

	os_set=()
	cpu_set=()
```
这样，os 和 cpu 在每次 forloop 的时候，都是为空吗？

## 补充一个 bash 这也可以，那也可以的例子
```c
RECORD_TIME=false

if [[ $RECORD_TIME == true ]]; then
  nix-shell --command "make clean"
  SECONDS=0
fi

if [[ $RECORD_TIME == true ]]; then
  duration=$SECONDS
  echo "$((duration / 60)) minutes and $((duration % 60)) seconds elapsed."
  echo "$(date) : $duration : " >>/home/martins3/core/compile-linux/database
  cat /proc/cmdline >>/home/martins3/core/compile-linux/database
fi
```
