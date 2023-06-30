local function microsoft_edge()
  if vim.loop.os_uname().sysname == "Linux" then
    return "microsoft-edge-beta $fileName"
  else
    return "/Applications/Microsoft\\ Edge.app/Contents/MacOS/Microsoft\\ Edge $file"
  end
end

require("code_runner").setup({
  term = {
    position = "belowright",
    size = 15,
  },
  filetype = {
    python = "python3 $file",
    c = "cd $dir && gcc -Wall -lpthread -fno-omit-frame-pointer -pg -g "
      .. "-lm $fileName -o $fileNameWithoutExt.out && $dir/$fileNameWithoutExt.out",
    cpp = "cd $dir && g++ -std=c++20 -lpthread -g $fileName -o"
      .. "$fileNameWithoutExt.out  && $dir/$fileNameWithoutExt.out",
    sh = "bash $file",
    html = microsoft_edge(),
    rust = "cargo run",
    r = "Rscript $file",
    lua = "lua $file",
    nix = "nix eval -f $file",
  },
})
