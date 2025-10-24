require("usr.options")
require("usr.lazy")
require("usr.mason")
require("usr.cmp")
require("usr.code_runner")
require("usr.hydra")
require("usr.nvim-tree")
require("usr.nvim-treesitter")
require("usr.orgmode")
require("usr.telescope")
require("usr.version")
require("usr.which-key")
require("usr.colorscheme")
require("usr.bufferline")
require("usr.lualine")
require("usr.neovide")
require("usr.util")
require("usr.toggleterm")
require("colorizer").setup({ "css", "javascript", "lua", html = { mode = "foreground" } })
require("nvim-surround").setup()
require("gitsigns").setup({ signcolumn = false, numhl = true })
require("leap").add_default_mappings()
require("flit").setup({})
require("nvim-autopairs").setup()
require("fidget").setup()
require("debugprint").setup()

-- require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" })
require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "~/.config/nvim/snippets/" } })
-- require("luasnip.loaders.from_vscode").load({paths = "~/.config/nvim/snippets"})

-- 书签
require("bookmarks").setup({
  mappings_enabled = true,
  keymap = {
    toggle = "mc",
    delete = "dd",
  },
  virt_pattern = { "*.lua", "*.md", "*.c", "*.h", "*.sh", "*.py" },
})

require("persisted").setup({
  autoload = true,
  should_save = function()
    -- Do not save if the alpha dashboard is the current filetype
    if vim.bo.filetype == "NvimTree" then
      return false
    end
    return true
  end,
})

require('gitsigns').setup {
  current_line_blame = true,
}
