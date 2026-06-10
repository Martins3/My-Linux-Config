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
  "ruff",
  "ty",
  "vimls",
  "yamlls",
  "perlnavigator",
  "tinymist",
  -- "typos_lsp",
  -- "tsserver",
}

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = servers,
  automatic_enable = servers,
}
-- lsp 很容易到达 1G ，只看关键的，需要用的时候再打开
-- 但是这个日志过期了
-- vim.lsp.set_log_level(vim.log.levels.ERROR)

-- ccls 不能支持
-- clangd 在 aarch64 安装有问题
vim.lsp.enable({ 'ccls', 'clangd', 'nixd' })
-- 虽然打开这个会让
-- 打开这个选项会让 telescope ui 不正常
-- vim.o.winborder = 'rounded'

vim.diagnostic.config({
  virtual_text = false, -- 关闭右侧文字，只保留悬浮窗
  signs = true,         -- 左侧图标保留
  float = { border = 'rounded' },
})

-- 光标停留时自动显示诊断
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function() vim.diagnostic.open_float(nil, { focusable = false }) end,
})

local map = vim.keymap.set
map({ "n", "x" }, "<space>lf", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })
