-- 在 https://github.com/williamboman/mason-lspconfig.nvim 中含有所有支持的 lsp
local servers = {
  "bashls",
  "cssls",
  "efm",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "pyright",
  "rust_analyzer",
  "vimls",
  "yamlls",
  -- "tsserver",
}

local settings = {
  ui = {
    border = "none",
    icons = {
      package_installed = "◍",
      package_pending = "◍",
      package_uninstalled = "◍",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
  PATH = "append", -- mason 如果系统中安装
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local all_servers = {"ccls", "nixd"}
for i = 1, #servers do
  all_servers[#all_servers + 1] = servers[i]
end

local opts = {}

for _, server in pairs(all_servers) do
  opts = {
    on_attach = require("usr.lsp.handlers").on_attach,
    capabilities = require("usr.lsp.handlers").capabilities,
  }

  server = vim.split(server, "@")[1]

  local require_ok, conf_opts = pcall(require, "usr.lsp.settings." .. server)
  if require_ok then
    opts = vim.tbl_deep_extend("force", conf_opts, opts)
  end

  -- vim.api.nvim_err_writeln(opts)
  lspconfig[server].setup(opts)
end
