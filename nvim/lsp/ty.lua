local python = require("usr.python")

return {
  root_dir = function(bufnr, on_dir)
    local root = python.find_project_root(bufnr)
    if root then
      on_dir(root)
    end
  end,
  before_init = function(_, config)
    local root = config.root_dir or python.project_root(0)
    local venv_python = python.venv_python(root)
    if venv_python == nil then
      return
    end

    config.settings = config.settings or {}
    config.settings.ty = config.settings.ty or {}
    config.settings.ty.configuration = config.settings.ty.configuration or {}
    config.settings.ty.configuration.environment = config.settings.ty.configuration.environment or {}
    config.settings.ty.configuration.environment.python = venv_python
  end,
  settings = {
    ty = {
      diagnosticMode = "openFilesOnly",
    },
  },
}
