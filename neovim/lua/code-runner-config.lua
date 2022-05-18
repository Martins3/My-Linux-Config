require('code_runner').setup {
  term = {
    position = "belowright",
    size = 15,
  },
  filetype = {
    python = "python3 $fileName",
    c = "cd $dir && clang -lpthread -g -lm $fileName -o $fileNameWithoutExt.out  && $dir/$fileNameWithoutExt.out",
    cpp = "cd $dir && clang++ -lpthread -g $fileName -o $fileNameWithoutExt.out  && $dir/$fileNameWithoutExt.out",
    html = "microsoft-edge $fileName",
    sh = "bash $file",
    rust = "cargo run",
    r = "Rscript $fileName"
  },
}
