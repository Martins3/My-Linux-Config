## edit:
- "| 单位    | 向左移动 | 向右移动 | 向左删除  | 向右删除 |"
- "| 字符    | Ctrl + B | Ctrl + F | Ctrl + H  | Ctrl + D |"
- "| 单词    | Alt + B  | Alt + F  | Ctrl + W  | Alt + D  |"
- "| 行首/尾 | Ctrl + A | Ctrl + E | Ctrl + U  | Ctrl + K |"

## rpm
- rpm -qa 查询当前系统中安装的所有的包
- rpm -ivh --force --nodeps url
- rpm -Uvh url : vh 升级的时候打出来进度条和日志，但是，-U 和 -i 的区别是升级和安装。
- rpm -qf 可以找到一个文件对应的包
- yum whatprovides xxd
- rpm -q --changelog php
- rpm -ql bison.rpm 检查 rpm 中存在多少文件
- rpm -qp bison.rpm 检查这就是一个 rpm 文件
- rpm -q --scripts 执行脚本

## find
- "find /tmp -size 0 -print0 -delete: 删除大小为 0 的文件"
- "@todo 这里没有完全搞清楚"
- "find 和 xargs 混合使用的时候，分别加上 -print0 和 -0"
- "find . -type f -print0 | xargs -0 md5sum"
- "https://www.shellcheck.net/wiki/SC2038"
- "hash: find path/to/folder -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum"

## git
- git ls-files --others --exclude-standard >> .gitignore
  - 将没有被跟踪的文件添加到 .gitignore 中
- git reset : 将所有的内容 unstage
- git checkout -- fs/ : 将 unstage 的修改删除掉

### git log
- git log --format="%h --> %B"
- git log -S <string> path/to/file : 如果 git blame 一个已经被删除的内容
- tig -- path/to/dir : 看一个目录的 log

- -> 如何删除一个已经提交的行为
- git reset --hard HEAD~1
- git push -f <remote> <branch>
- git tag -d tagname
- git push --delete origin tagname
- -> 仅仅 push 一个 tag
- git push origin tagname
### 将本地设置为和远程完全相同
- git fetch origin
- git reset --hard origin/master
- -> 如何将多个 commit squash 一下
- git reset --soft HEAD~3 && git commit
- -> 撤销一个 commit
- git reset --soft HEAD^
- -> 拉取 tags
- git fetch --tags
- -> 在一个特定的 commit 上打 tag
- git tag tagname fb24344513a2ce7dd870c8b002485ded9758d475

### git patch
将 patch 直接作为一个 commit，而不是 diff 信息
-v 是参数个数。

- git format-patch -1 sha1 # 指定一个具体的 sha1
- git format-patch -1 HEAD # 指定当从当前的 HEAD
- git format-patch -1  # HEAD 是默认的
- git format-patch -1 -v # 说明 patch 的版本
- git am

## redirect
- https://wizardzines.com/comics/redirects/
- ls > /dev/null
- ls 2> /dev/null
- ls &> /dev/null
- cat < file

## python
- "python -m venv .venv"
- "source .venv/bin/activate"

## grep
- "-o, --only-matching : 仅仅打印匹配的部分而不是该行"
- "grep -nr 'yourString.*' . : rg 没有的时候用下, -r 表示 recursive"
- "grep -e aaa -e bbb : 同时搜索两个"
- "grep -n -C 2 something * : -C 2 表示展示行数 -n 展示行号"

## printf
- 打印数组，是针对所有成员一次操作的

## curl
- curl -LO --output-dir . www.baidu.com
- -L 如果发生了重定向，那么继续重定向
- -O 使用远程的名称
- --output-dir 只有比较新的版本才支持

## dd
- dd if=/dev/zero of=pmem count=4 bs=10M # 基本测试
- dd if=ubuntu-22.04.2-desktop-amd64.iso of=/dev/sdc # 使用 dd 安装系统

## ps
- ps --ppid 2 -p 2 -o uname,pid,ppid,cmd,cls
  - 列举出来所有的内核线程
  - https://unix.stackexchange.com/questions/411159/linux-is-it-possible-to-see-only-kernel-space-threads-process
  - # @todo 理解一下这是啥含义
- ps -elf # @todo 这个几个都是啥含义
- ps aux --sort -rss # 对于内存数量排序

## vimscript:
- "调试方法 echom 然后 :message 查看，注意不能是 echo"

## nvim:
- vim.api.nvim_err_writeln("hello \n") -- 不要忘记 \n
- nvim "+let g:auto_session_enabled = v:false" -c ":e mm/gup.c" -c "lua vim.loop.new_timer():start(1000 * 60 * 30, 0, vim.schedule_wrap(function() vim.api.nvim_command(\"exit\") end))"
- \r 是换行
- :%s/$/abc/ 来给每一行的最后增加 abc

## screen:
- screen -d -m sleep 1000
- screen -r
- screen -list
## stress:
- stress-ng --vm-bytes 40000M --vm-keep --vm 8
## gnome:
- eog # 在终端中打开图片
- nautilus --browser . # 在终端中打开当前目录


## Shell
- export PS1="\W" : 命令提示符只有 working dir

## tar
- tar cvzf name_of_archive_file.tar.gz name_of_directory_to_tar
  - https://unix.stackexchange.com/questions/46969/compress-a-folder-with-tar
  - z : 使用 gzip 压缩
- tar -xvf

## systemd
- systemctl --user list-timers --all
- systemctl list-timers --all
- systemctl list-unit-files


## centos
- nmcli networking off
- nmcli networking on
- 在 /etc/resolv.conf 中增加，如果遇到 `wget: unable to resolve host address`
nameserver 114.114.114.114

## sudo
- 让 sudo https://unix.stackexchange.com/questions/83191/how-to-make-sudo-preserve-path


## sshfs

```sh
mkdir mnt
sshfs martins3@10.0.2.2:path_to_repo  ~/mnt
```
