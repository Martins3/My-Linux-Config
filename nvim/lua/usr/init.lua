require("usr.options")
require("usr.rustaceanvim")
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
if vim.g.neovide then
  require("usr.neovide")
end
require("usr.util")
require("nvim-surround").setup()
require("gitsigns").setup({
  signcolumn = false,
  numhl = true,
  current_line_blame = true,
})
require("nvim-autopairs").setup()

vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')

-- require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" })
require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "~/.config/nvim/snippets/" } })
-- require("luasnip.loaders.from_vscode").load({paths = "~/.config/nvim/snippets"})

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

-- ssh 到远端，neovim 可以拷贝到本地
-- FIXME 真的是按下了葫芦起了瓢，现在 ProcessClipboard 不能用了，我靠
vim.g.clipboard = 'osc52'
