 已处理。你这个项目的 .clangd:1 已经开了：

  Diagnostics:
    UnusedIncludes: Strict

  所以缺的是 nvim 侧直接应用 clangd fix-it。我加了：

  - /home/martins3/.dotfiles/nvim/lsp/clangd.lua:23：新增 :ClangdRemoveUnusedIncludes，会筛选 clangd 的 unused-
    includes 诊断并应用 remove all unused includes
  - /home/martins3/.dotfiles/nvim/lua/usr/which-key.lua:80：绑定 <space>li

  用法：打开 C/C++ 文件，等 clangd 报出 unused include 后，按 <space>li，或者执行：

  :ClangdRemoveUnusedIncludes

  验证过：

  nvim --headless +'lua require("usr")' +qa
  nvim --headless src/server.c +'lua print(vim.fn.exists(":ClangdRemoveUnusedIncludes"))'
  +'ClangdRemoveUnusedIncludes' +qa

  第二个确认命令已注册；当前 src/server.c 没有已发布的 unused include 诊断，所以提示 no diagnostics。

  参考：clangd 的 Include Cleaner 文档说明 Diagnostics.UnusedIncludes 控制 unused include 诊断，clangd 源码里对应
  fix-it 名称是 remove #include directive / remove all unused includes。
  https://clangd.llvm.org/guides/include-cleaner
  https://codebrowser.dev/llvm/clang-tools-extra/clangd/IncludeCleaner.cpp.html


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
