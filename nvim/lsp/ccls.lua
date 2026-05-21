local roots = require("usr.lsp_roots")

return {
  root_dir = function(bufnr, on_dir)
    local root = roots.find_c_root(bufnr)
    if roots.is_linux_kernel_root(root) then
      on_dir(root)
    end
  end,

  init_options = {
    index = {
      threads = 0,
    },
    clang = {
      excludeArgs = { "-Wall" },
    },

    highlight = {
      lsRanges = true,
    },

    client = {
      snippetSupport = true,
    },
  },
}
