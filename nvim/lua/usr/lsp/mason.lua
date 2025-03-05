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
  "vimls",
  "yamlls",
  "perlnavigator",
  -- "typos_lsp",
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
  PATH = "append",
  -- 如果系统中安装对应的 lsp，优先使用系统中的 lsp
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

-- TODO lspconfig 到底是什么作用来着 ?
-- 由于动态库的原因 Mason 安装的在 nixos 中无法使用
-- TODO  typos_lsp 需要一些特殊的配置才可以正常工作，否则很容易误报
local all_servers = { "ccls", "nixd", }
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

  -- TODO 其实都可以合并起来的，不要搞这些无聊的文件了
  -- 如果有额外的配置，那么加载 nvim/lua/usr/lsp/settings/ 下配置
  -- 配置参考 https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ccls
  local require_ok, conf_opts = pcall(require, "usr.lsp.settings." .. server)
  if require_ok then
    opts = vim.tbl_deep_extend("force", conf_opts, opts)
  end

  -- vim.api.nvim_err_writeln(opts)
  lspconfig[server].setup(opts)
end
