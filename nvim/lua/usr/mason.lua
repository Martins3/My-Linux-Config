-- Add the same capabilities to ALL server configurations.
-- Refer to :h vim.lsp.config() for more information.
vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities()
})

local servers = {
  "bashls",
  "cssls",
  "efm",
  "html",
  "jsonls",
  "lua_ls",
  -- "marksman", 不够稳定，而且 CPU 消耗高
  "pyright",
  "vimls",
  "yamlls",
  "perlnavigator",
  -- "typos_lsp",
  -- "tsserver",
}

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = servers
}
vim.lsp.enable({ 'ccls', 'nixd' })
-- 虽然打开这个会让
-- 打开这个选项会让 telescope ui 不正常
-- vim.o.winborder = 'rounded'

vim.diagnostic.config({
  -- virtual_lines 造成了巨大的视觉干扰，还是 virtual_text 好用
  -- virtual_lines = { current_line = true, },
  virtual_text = { current_line = true, },
})

local map = vim.keymap.set
map({ "n", "x" }, "<space>lf", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })
