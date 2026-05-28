local root_markers = {
  "ty.toml",
  "pyproject.toml",
  "uv.lock",
  ".git",
}

local function find_project_root(bufnr)
  return vim.fs.root(bufnr, root_markers)
end

local function project_python(bufnr)
  local root = find_project_root(bufnr) or vim.fn.getcwd()
  local python = root .. "/.venv/bin/python"
  if vim.fn.executable(python) == 1 then
    return python
  end
end

return {
  root_dir = function(bufnr, on_dir)
    local root = find_project_root(bufnr)
    if root then
      on_dir(root)
    end
  end,
  before_init = function(_, config)
    local python = project_python(0)
    if python == nil then
      return
    end

    config.settings = config.settings or {}
    config.settings.ty = config.settings.ty or {}
    config.settings.ty.configuration = config.settings.ty.configuration or {}
    config.settings.ty.configuration.environment = config.settings.ty.configuration.environment or {}
    config.settings.ty.configuration.environment.python = python
  end,
  settings = {
    ty = {
      diagnosticMode = "openFilesOnly",
    },
  },
}
