## 原来 .clangd 也有自己的配置文件
```txt
CompileFlags:
  CompilationDatabase: .

Diagnostics:
  UnusedIncludes: Strict
  MissingIncludes: Strict
```

## 原来 clangd 是配合 clang-tidy 使用的

因为，现在的 clangd 配置中携带了 --clangd-tidy 的，所以，可以观察到 .clang-tidy 中内容变化，nvim 中的内容马上变化:

```txt
clang-tidy -p . nbd.c
```

```txt
clangd --check=./nbd.c \
    --compile-commands-dir=. \
    --clang-tidy
```
