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

local function windows_system_programming_runner()
  if vim.loop.os_uname().sysname ~= "Windows_NT" then
    return nil
  end

  local root = vim.fs.normalize("C:/Users/97936/data/vn/docs/windows/code")
  local file = vim.fs.normalize(vim.fn.expand("%:p"))
  if not vim.startswith(file, root .. "/src/") then
    return nil
  end

  local runner = root .. "/scripts/run_demo.ps1"
  -- Keep Windows/CMake details in a PowerShell file so code_runner only expands the
  -- target name and does not have to pass a long quoted script through pwsh.
  return runner .. " $fileNameWithoutExt"
end

local function cpp_runner()
  return windows_system_programming_runner()
    or "cd $dir && g++ -std=c++20 -lpthread -g $fileName -o"
      .. "$fileNameWithoutExt.out  && $dir/$fileNameWithoutExt.out"
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
    cpp = cpp_runner,
    sh = "bash $file",
    html = microsoft_edge(),
    r = "Rscript $file",
    lua = "lua $file",
    nix = "nix eval -f $file",
    ps1 = "powershell -ExecutionPolicy Bypass -File $file",
  },
})
