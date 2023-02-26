# 这一次我要学会 bash

基本参考 [Bash 脚本教程](https://wangdoc.com/bash/index.html)

![](https://preview.redd.it/8a7tpszpdgj41.png?width=640&height=360&crop=smart&auto=webp&s=04e05726a9bb67ff47a8599101931409953859a0)

## 问题
- 学会使用 dirname 和 basename
- [ ] [The art of command line](https://github.com/jlevy/the-art-of-command-line/blob/master/README-zh.md#%E4%BB%85%E9%99%90-os-x-%E7%B3%BB%E7%BB%9F)

## [ ] http://mywiki.wooledge.org/BashPitfalls

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

## 字符串
```sh
数组长度
${#name}
```

```sh
STR="/path/to/foo.cpp"
echo ${STR%.cpp}    # /path/to/foo
echo ${STR##*.}     # cpp (extension)
echo ${STR##*/}     # foo.cpp (basepath)
```

## 数组
拷贝:
hobbies=( "${activities[@]}" )
增加一项:
hobbies=( "${activities[@]}" diving )
myIndexedArray+=('six')
用 unset 命令来从数组中删除一个元素：
unset fruits[0]

使用 @ 和 `*` 来循环数组是否存在双引号的情况各不相同。
- 如果没有，忽视双引号，逐个拆开
- 如果有，`*` 是一个，而 @ 不会逐个拆开

```sh
function xxx () {
echo "Using \"\$*\":"
for a in "$*"; do
    echo $a;
done

echo -e "\nUsing \$*:"
for a in $*; do
    echo $a;
done

echo -e "\nUsing \"\$@\":"
for a in "$@"; do
    echo $a;
done

echo -e "\nUsing \$@:"
for a in $@; do
    echo $a;
done

}
xxx one two "three four"
```
参考:
- https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
- https://stackoverflow.com/questions/12314451/accessing-bash-command-line-args-vs

https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html
https://blog.k8s.li/shell-snippet.html
- [x] 单引号和双引号的区别
  - https://stackoverflow.com/questions/6697753/difference-between-single-and-double-quotes-in-bash
  - 但是实际上，这个解释是有问题的, 实际上是三个特殊字符除外：美元符号（`$`）、反引号（`\`）和反斜杠（`\`) 其余都是在双引号被取消掉
  - 而单引号会取消掉任何，甚至包括反斜杠

## 有用的变量

| var     |                                |
|---------|--------------------------------|
| SECCOND | 记录除了给上一次到这一次的时间 |

## eval 和 exec 的区别
https://unix.stackexchange.com/questions/296838/whats-the-difference-between-eval-and-exec/296852

- eval 相当于执行这个函数
- exec 继续执行程序

## 算术运算
使用这个，而不是 let expr 之类的 $((1+2))


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
2. 使用 set -x set +x 组合来调试特定位置的代码
3. 打印函数名称和调用的参数

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

## shell 中移动
- http://blog.jcix.top/2021-10-05/shell-shortcuts/

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


## printf 有什么神奇的地方吗？

## shellcheck 也是有问题的
1. common.sh 可以解决一下吗？
2. 如果我就是想要 glob ，怎么操作

3. bash 中的 regex 到底是什么样子的

