require("usr.options")
require("usr.lazy")
require("usr.lsp")
require("usr.cmp")
require("usr.bufferline")
require("usr.code_runner")
require("usr.hydra")
require("usr.nvim-tree")
require("usr.nvim-treesitter")
require("usr.orgmode")
require("usr.telescope")
require("usr.version")
require("usr.which-key")
require("usr.colorscheme")
require("usr.alpha")
require("colorizer").setup({ "css", "javascript", "vim", html = { mode = "foreground" } })
require("nvim-surround").setup()
require("persisted").setup({ autoload = true })
require("gitsigns").setup({ signcolumn = false, numhl = true })
require("leap").add_default_mappings()
require("nvim-autopairs").setup()
require("fidget").setup()
require("nvim-navic").setup()
require("barbecue").setup()
require("nvim-lightbulb").update_lightbulb()
require("im_select").setup()
require("lualine").setup()
require("rsync").setup()
-- require("hardtime").setup() # 一时难以适应
require("hbac").setup() -- 和 session 有点冲突，但是很不错的

-- require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" })
require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/snippets/" })
-- require("luasnip.loaders.from_vscode").load({paths = "~/.config/nvim/snippets"})

-- workaround for https://github.com/neovim/neovim/issues/21856
vim.api.nvim_create_autocmd({ "VimLeave" }, {
  callback = function()
    vim.cmd("sleep 10m")
  end,
})

-- 导航栏
require("aerial").setup({
  backends = { "markdown", "man", "lsp", "treesitter" },
  layout = {
    max_width = { 30, 0.15 },
    placement = "edge",
    default_direction = "left",
  },
  attach_mode = "global",
})

-- 书签
require("bookmarks").setup({
  mappings_enabled = false,
  virt_pattern = { "*.lua", "*.md", "*.c", "*.h", "*.sh" },
})

-- 自动同步
require("rsync").setup({
  sync_on_save = false, -- 默认关闭
})
