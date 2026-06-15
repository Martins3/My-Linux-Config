local function microsoft_edge()
  if vim.loop.os_uname().sysname == "Linux" then
    return "google-chrome-stable $fileName"
  else
    return "/Applications/Microsoft\\ Edge.app/Contents/MacOS/Microsoft\\ Edge $file"
  end
end

local function cuda_tutorial_runner()
  local root = vim.fs.normalize("/home/martins3/data/vn/gpu/cuda/tutorial")
  local file = vim.fs.normalize(vim.fn.expand("%:p"))

  if not vim.startswith(file, root .. "/") then
    return nil
  end

  return "cd " .. vim.fn.shellescape(root) .. " && make -j && $dir/$fileNameWithoutExt.out"
end

require("code_runner").setup({
  term = {
    position = "belowright",
    size = 15,
  },
  project = {
    ["/home/martins3/data/leetgpu-challenges"] = {
      name = "leetgpu-challenges",
      command = "bash run.sh",
    },
  },
  filetype = {
    python = function()
      return require("usr.python").run_file_command()
    end,
    cuda = cuda_tutorial_runner,
    c = "cd $dir && gcc -Wall -lpthread -fno-omit-frame-pointer -pg -g "
      .. "-lm $fileName -o $fileNameWithoutExt.out && $dir/$fileNameWithoutExt.out",
    cpp = "cd $dir && g++ -std=c++20 -lpthread -g $fileName -o"
      .. "$fileNameWithoutExt.out  && $dir/$fileNameWithoutExt.out",
    sh = "bash $file",
    html = microsoft_edge(),
    r = "Rscript $file",
    lua = "lua $file",
    nix = "nix eval -f $file",
    ps1 = "powershell -ExecutionPolicy Bypass -File $file",
  },
})
