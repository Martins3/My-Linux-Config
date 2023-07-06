# unix 文本处理

学一次，忘一次

- https://learnbyexample.github.io/cli_text_processing_coreutils/tr.html : 讲解各种 text processing 的事情，值得单独作为一个章节来分析。

## tr

- 大小写转换
```sh
tr '[:lower:]' '[:upper:]' <greeting.txt
```

- 过滤数字
echo toto.titi.3312.tata.2.abc.def | tr -d -c 0-9

## cut

- -f 后面跟着的参数类似 array 的 slice 的感觉
```sh
echo 'one;two;three;four' | cut -d';' --output-delimiter=$'\t' -f1,3-
```

## seq

类似 python 中的 range

seq 3
