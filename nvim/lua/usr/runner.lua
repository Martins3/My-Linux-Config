local M = {}

local function windows()
  return vim.fn.has("win32") == 1
end

local function shell_name()
  return vim.fn.fnamemodify(vim.o.shell, ":t:r"):lower()
end

function M.is_nu()
  return shell_name() == "nu"
end

local function powershell()
  return shell_name() == "pwsh" or shell_name() == "powershell"
end

local function quote(value)
  if M.is_nu() then
    return vim.json.encode(value)
  elseif powershell() then
    return "'" .. value:gsub("'", "''") .. "'"
  end
  return vim.fn.shellescape(value)
end

-- 参数单独引用；$end 阻止 code_runner 再追加一次当前文件名。
function M.command(template, ...)
  local args = { ... }
  for i, value in ipairs(args) do
    args[i] = quote(value)
  end
  return template:format(unpack(args)) .. " $end"
end

local function invoke(argv)
  local args = vim.tbl_map(quote, argv)
  local prefix = M.is_nu() and "^" or (powershell() and "& " or "")
  return prefix .. table.concat(args, " ")
end

local function sequence(commands, cwd)
  local separator = " && "
  if M.is_nu() then
    separator = "; if $env.LAST_EXIT_CODE != 0 { exit $env.LAST_EXIT_CODE }; "
  elseif powershell() then
    separator = "; if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }; "
  end
  local command = table.concat(commands, separator)
  if cwd then
    if powershell() then
      command = "Set-Location -LiteralPath " .. quote(cwd) .. " -ErrorAction Stop; " .. command
    elseif M.is_nu() then
      command = "cd " .. quote(cwd) .. "; " .. command
    else
      command = (windows() and shell_name() == "cmd" and "cd /d " or "cd ") .. quote(cwd) .. " && " .. command
    end
  end
  return command .. " $end"
end

local function file()
  return vim.fs.normalize(vim.api.nvim_buf_get_name(0))
end

local function find_tool(candidates)
  for _, candidate in ipairs(candidates) do
    if candidate ~= "" and vim.fn.executable(candidate) == 1 then
      local resolved = vim.fn.exepath(candidate)
      return vim.fs.normalize(resolved ~= "" and resolved or candidate)
    end
  end
end

local function windows_project()
  if not windows() then return end
  local path = file()
  for root in vim.fs.parents(path) do
    if root:match("/docs/windows/code$") and path:sub(#root + 1, #root + 5) == "/src/" then
      local script = root .. "/scripts/run_demo.ps1"
      if vim.fn.filereadable(script) == 1 then
        local shell = find_tool({ "pwsh", "powershell" }) or "powershell"
        return sequence({ invoke({ shell, "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
          script, vim.fn.fnamemodify(path, ":t:r") }) })
      end
    end
  end
end

local function compile_run(compiler, flags, libraries)
  local source = file()
  local output = vim.fn.fnamemodify(source, ":r") .. (windows() and ".exe" or ".out")
  local argv = { compiler }
  vim.list_extend(argv, flags)
  vim.list_extend(argv, { source, "-o", output })
  vim.list_extend(argv, libraries or {})
  return sequence({ invoke(argv), invoke({ output }) }, vim.fs.dirname(source))
end

function M.c()
  local project = windows_project()
  if project then return project end
  return compile_run(find_tool({ "gcc" }) or "gcc",
    { "-Wall", "-fno-omit-frame-pointer", "-pg", "-g" }, { "-lpthread", "-lm" })
end

function M.cpp()
  local project = windows_project()
  if project then return project end
  return compile_run(find_tool({ "g++" }) or "g++", { "-std=c++20", "-g" }, { "-lpthread" })
end

local function msvc()
  local cl = find_tool({ "cl" })
  if cl then return cl end
  local installer = (vim.env["ProgramFiles(x86)"] or "C:/Program Files (x86)") .. "/Microsoft Visual Studio/Installer/vswhere.exe"
  local vswhere = find_tool({ "vswhere", installer })
  if vswhere then
    local result = vim.system({ vswhere, "-latest", "-products", "*", "-requires",
      "Microsoft.VisualStudio.Component.VC.Tools.x86.x64", "-find",
      "VC/Tools/MSVC/*/bin/Hostx64/x64/cl.exe" }, { text = true }):wait(5000)
    if result.code == 0 then
      local paths = vim.split(vim.trim(result.stdout or ""), "\n", { trimempty = true })
      table.sort(paths)
      for i = #paths, 1, -1 do
        cl = find_tool({ vim.trim(paths[i]) })
        if cl then return cl end
      end
    end
  end
end

function M.cuda()
  local source = file()
  if not windows() then
    for root in vim.fs.parents(source) do
      if root:match("/gpu/cuda/tutorial$") and vim.fn.filereadable(root .. "/Makefile") == 1 then
        local make = find_tool({ "make" }) or "make"
        local output = vim.fn.fnamemodify(source, ":r") .. ".out"
        return sequence({ invoke({ make, "-j", output:sub(#root + 2) }), invoke({ output }) }, root)
      end
    end
  end
  local candidates = { "nvcc" }
  if vim.env.CUDA_PATH then
    candidates[#candidates + 1] = vim.env.CUDA_PATH .. "/bin/" .. (windows() and "nvcc.exe" or "nvcc")
  end
  if windows() then
    candidates[#candidates + 1] = vim.fn.expand("~/.local/share/cuda/v13.1/bin/nvcc.exe")
  end
  local nvcc = find_tool(candidates) or "nvcc"
  local flags = vim.deepcopy(vim.g.runner_cuda_flags or { "-std=c++17", "-O2", "-g" })
  if windows() then
    local cl = msvc()
    if cl then
      -- nvcc 根据 -ccbin 找到 MSVC，并执行其环境初始化脚本。
      vim.list_extend(flags, { "-ccbin", vim.fs.dirname(cl) })
    end
  end
  return compile_run(nvcc, flags)
end

return M
