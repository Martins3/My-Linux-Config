-- 哦，codex 一下子生成了好多代码，就是为了可以自动的运行测试
local M = {}

local uv = vim.uv or vim.loop

local function exists(path)
  return path and uv.fs_stat(path) ~= nil
end

local function executable(path)
  return path and vim.fn.executable(path) == 1
end

local function shellescape(value)
  return vim.fn.shellescape(value)
end

M.root_markers = {
  "ty.toml",
  "pyproject.toml",
  "uv.lock",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
  ".venv",
  ".git",
}

function M.find_project_root(bufnr)
  bufnr = bufnr or 0
  return vim.fs.root(bufnr, M.root_markers)
end

function M.project_root(bufnr)
  bufnr = bufnr or 0
  return M.find_project_root(bufnr) or vim.fn.getcwd()
end

function M.has_uv_project(root)
  if vim.fn.executable("uv") ~= 1 then
    return false
  end

  if exists(root .. "/uv.lock") then
    return true
  end

  local pyproject = root .. "/pyproject.toml"
  if not exists(pyproject) then
    return false
  end

  for _, line in ipairs(vim.fn.readfile(pyproject, "", 200)) do
    if line:match("^%s*%[tool%.uv[%].]") then
      return true
    end
  end

  return false
end

function M.venv_executable(root, name)
  local path = root .. "/.venv/bin/" .. name
  if executable(path) then
    return path
  end
end

function M.venv_python(root)
  return M.venv_executable(root, "python")
end

function M.python_cmd(root)
  local venv_python = M.venv_python(root)
  if venv_python then
    return shellescape(venv_python)
  end

  if M.has_uv_project(root) then
    return "uv run python"
  end

  return "python3"
end

function M.ipython_cmd(root)
  local venv_ipython = M.venv_executable(root, "ipython")
  if venv_ipython then
    return shellescape(venv_ipython)
  end

  if M.has_uv_project(root) then
    return "uv run ipython"
  end

  return "ipython"
end

function M.pytest_cmd(root)
  local venv_python = M.venv_python(root)
  if venv_python then
    return shellescape(venv_python) .. " -m pytest"
  end

  if M.has_uv_project(root) then
    return "uv run pytest"
  end

  return "python3 -m pytest"
end

function M.run_file_command()
  local root = M.project_root(0)
  local file = vim.api.nvim_buf_get_name(0)
  return "cd " .. shellescape(root) .. " && " .. M.python_cmd(root) .. " " .. shellescape(file)
end

function M.ipython_command()
  local root = M.project_root(0)
  return "cd " .. shellescape(root) .. " && " .. M.ipython_cmd(root)
end

local function line_indent(line)
  return #(line:match("^%s*") or "")
end

function M.current_test_target()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return nil
  end

  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, cursor_line, false)
  local test_name
  local test_line
  local test_indent

  for i = #lines, 1, -1 do
    local line = lines[i]
    local name = line:match("^%s*async%s+def%s+(test[%w_]*)%s*%(")
        or line:match("^%s*def%s+(test[%w_]*)%s*%(")
    if name then
      test_name = name
      test_line = i
      test_indent = line_indent(line)
      break
    end

    name = line:match("^%s*class%s+(Test[%w_]*)%s*[%(:]")
    if name then
      return shellescape(file .. "::" .. name)
    end
  end

  if not test_name then
    return shellescape(file)
  end

  local class_name
  for i = test_line - 1, 1, -1 do
    local line = lines[i]
    local name = line:match("^%s*class%s+(Test[%w_]*)%s*[%(:]")
    if name and line_indent(line) < test_indent then
      class_name = name
      break
    end
  end

  if class_name then
    return shellescape(file .. "::" .. class_name .. "::" .. test_name)
  end

  return shellescape(file .. "::" .. test_name)
end

function M.pytest_command(target)
  local root = M.project_root(0)
  target = target or shellescape(vim.api.nvim_buf_get_name(0))
  return "cd " .. shellescape(root) .. " && " .. M.pytest_cmd(root) .. " " .. target
end

return M
