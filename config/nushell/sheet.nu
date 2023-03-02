# @todo 也许可以找个更加结构化的方法
def e [] {
    let database = [
      {
        name: edit
        help: "
| 单位    | 向左移动 | 向右移动 | 向左删除  | 向右删除 |
| 字符    | Ctrl + B | Ctrl + F | Ctrl + H  | Ctrl + D |
| 单词    | Alt + B  | Alt + F  | Ctrl + W  | Alt + D  |
| 行首/尾 | Ctrl + A | Ctrl + E | Ctrl + U  | Ctrl + K |
        "
      }

      {
        name: rpm
        help: "
- rpm -qa 查询当前系统中安装的所有的包
- rpm -ivh --force --nodeps url
- rpm -qf 可以找到一个文件对应的包
- yum install whatprovides xxd
- rpm -q --changelog php
"
      }

      {
        name: find
        help: "
- find /tmp -size 0 -print0 -delete : 删除大小为 0 的文件
# @todo 这里没有完全搞清楚
- find 和 xargs 混合使用的时候，分别加上 -print0 和 -0
  - find . -type f -print0 | xargs -0 md5sum
  - https://www.shellcheck.net/wiki/SC2038
- hash: find path/to/folder -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum
"
      }

      {
        name: grep
        help: "

     -o, --only-matching : 仅仅打印匹配的部分而不是该行

     grep -nr 'yourString*' . : rg 没有的时候用下

        "
      }

      {
      name: git
      help: "
# 如何删除一个已经进行了的行为
git reset --hard HEAD~1
git push -f <remote> <branch>
git tag -d tagname
git push --delete origin tagname

# @todo 仅仅 push 一个 tag ?


      "
      }
      # @todo 补充一下 regex 的内容
      # @todo printf
      # zat /boot/initramfs | cpio -idmv
      # systemctl list-units
# Use docker ps to get the name of the existing container
# Use the command docker exec -it <container name> /bin/bash to get a bash shell in the container
    ]
    let name = ($database | each { |it| $it.name } | str collect "\n" | fzf)
    let help = ($database | each { |it| if $it.name == $name { $it.help } } | str collect "\n")
    gum style --foreground 212 --border-foreground 212 --border double --align left --margin "0 0 " --padding "0 0 " $"($help)"
}
