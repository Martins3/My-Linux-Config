local roots = require("usr.lsp_roots")

return {
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  root_dir = function(bufnr, on_dir)
    local root = roots.find_clangd_root(bufnr)
    if root and not roots.is_linux_kernel_root(root) then
      on_dir(root)
    end
  end,
  filetypes = { 'c', 'cpp' },
}
