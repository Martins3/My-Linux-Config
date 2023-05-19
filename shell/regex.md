# Regex
## 基本学习路线
阅读[这个文档](https://github.com/ziishaned/learn-regex/blob/master/translations/README-cn.md)

但是更加推荐[交互式的教程](https://regexlearn.com/zh-cn) 和 [图形化演示](https://devtoolcafe.com/tools/regex#!flags=img&re=)

学习完成之后，通过这个[教程配套的 checksheet](https://regexlearn.com/zh-cn/cheatsheet) 来复习

用于[测试和解释 regex 的网站](https://regexr.com/)

[将 regex 转化为 plain English](https://www.autoregex.xyz/)

## 笔记
一些特殊字符用来指定一个字符在文本中重复的次数。它们分别是加号 +、星号 * 和问号 ?。
  - 我们在字符后面加上 *，表示一个字符完全不匹配或可以匹配多次。
  - 为了表示一个字符出现的确切次数，我们在该字符的末尾，将它出现的次数写进大括号 {} 中，如 {n}

- 单词 ha 和 haa 分组如下。第一组用 \1 来避免重复书写。这里的 1 表示分组的顺序。请在表达式的末尾键入 \2 以引用第二组。
  - 括号 (?: ): 非捕获分组
  - 竖线 : 出现在 () 中，表示多个的或，和 [] 不同，那个只是表示为字符集合
- ^ 在 [] 中表示取反，在整个表达式中表示开始
- \w 表示数字 字母 和 下划线
- \d 数值
- \s 空白字符
- 正向先行断言: (?=)
- 负向先行断言: (?!)
- 正向后行断言: (?<=)
- 标志: global multiline insensitive
- * 是默认的贪婪匹配，但是 *? 是 lazy 匹配
- [[:space:]]

## vim 的差别
vim 中使用 regex 参考[这个总结](https://learnbyexample.gitbooks.io/vim-reference/content/Regular_Expressions.html)

注意默认的时候，`+` `?` `{}` 需要通过 `\+` `\?` `\{}` 来访问，而 `()` 和 `|` 是不支持的。

就需要使用 magic ooption, 通过 `:h \v` 查询[^1]。

vim 中删除 trailing space 的命令 `:%s/\s\+$/`

## bash 的扩展模式的差别

|    | regex                    | expansion                                                |
|----|--------------------------|----------------------------------------------------------|
| ?  | 让表达式可选             | 一个字符                                                 |
| *  | 零个或者多个             | 字符代表文件路径里面的任意数量的任意字符，包括零个字符。 |
| [] | 括号之中的任意一个字符。 | 相同                                                     |
| {} | 描述个数                 | 大括号扩展{...}表示分别扩展成大括号里面的所有值          |

在字符串的替换使用的是 expansion
```c
str=aaabbb
echo ${str/?/sss}
```

## 有趣的文摘
- [使用 swift 打造一个自己的 regex 引擎](https://kean.blog/post/lets-build-regex)
- [melody : 一个可以编译为 regex 的语言](https://github.com/yoav-lavi/melody)


## 实在不行，使用 gpt 吧

## 为什么
ag "4.18.0-193.28.1.el7.smartx.\d+," 可以使用 \d ，但是 sed 不可以

## [ ] 此外，我的逆天的 tag generator

[^1]: https://thevaluable.dev/vim-advanced/
