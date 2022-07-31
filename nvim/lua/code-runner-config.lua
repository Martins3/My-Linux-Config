local function microsoft_edge()
  if vim.fn.has('macunix') then
    return "/Applications/Microsoft\\ Edge.app/Contents/MacOS/Microsoft\\ Edge $file"
  else
    return "microsoft-edge $fileName"
  end
end

require('code_runner').setup {
  term = {
    position = "belowright",
    size = 15,
  },
  filetype = {
    python = "python3 $file",
    c = "cd $dir && clang -lpthread -fno-omit-frame-pointer -pg -g -lm $fileName -o $fileNameWithoutExt.out  && $dir/$fileNameWithoutExt.out",
    cpp = "cd $dir && clang++ -lpthread -g $fileName -o $fileNameWithoutExt.out  && $dir/$fileNameWithoutExt.out",
    sh = "bash $file",
    html = microsoft_edge(),
    rust = "cargo run",
    r = "Rscript $file",
    lua = "lua $file",
    nix = "nix repl $file",
  },
}
