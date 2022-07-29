require('code_runner').setup {
  term = {
    position = "belowright",
    size = 15,
  },
  filetype = {
    python = "python3 $file",
    c = "cd $dir && clang -lpthread -fno-omit-frame-pointer -pg -g -lm $fileName -o $fileNameWithoutExt.out  && $dir/$fileNameWithoutExt.out",
    cpp = "cd $dir && clang++ -lpthread -g $fileName -o $fileNameWithoutExt.out  && $dir/$fileNameWithoutExt.out",
    -- TMP_TODO 如何让这个是自适应操作系统的
    -- html = "microsoft-edge $fileName",
    html = "/Applications/Microsoft\\ Edge.app/Contents/MacOS/Microsoft\\ Edge $file",
    sh = "bash $file",
    rust = "cargo run",
    r = "Rscript $file",
    lua = "lua $file",
    nix = "nix repl $file",
  },
}
