local function project_root(bufnr)
  return vim.fs.root(bufnr, {
    "pyproject.toml",
    "uv.lock",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".git",
  }) or vim.fn.getcwd()
end

local function project_python(bufnr)
  local python = project_root(bufnr) .. "/.venv/bin/python"
  if vim.fn.executable(python) == 1 then
    return python
  end
end

return {
  before_init = function(_, config)
    local python = project_python(0)
    if python == nil then
      return
    end

    config.settings = config.settings or {}
    config.settings.python = config.settings.python or {}
    config.settings.python.pythonPath = python
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "standard",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
}
