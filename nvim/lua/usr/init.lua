require("usr.options")
require("usr.rustaceanvim")
require("usr.lazy")
require("usr.mason")
require("usr.cmp")
require("usr.code_runner")
require("usr.hydra")
require("usr.nvim-tree")
require("usr.nvim-treesitter")
require("usr.telescope")
require("usr.version")
require("usr.which-key")
require("usr.terminal-smart-quit")
require("usr.colorscheme")
require("usr.ft")
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

vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
vim.keymap.set("n", "S", "<Plug>(leap-from-window)")

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

vim.g.clipboard = "osc52"



-- 当失去焦点或者离开当前的 buffer 的时候保存
local group = vim.api.nvim_create_augroup("CoreAutoSave", { clear = true })
local function save()
  local buf = vim.api.nvim_get_current_buf()
  if not vim.bo[buf].modifiable then
    return
  end
  if not vim.bo[buf].modified then
    return
  end
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("silent! write")
  end)
end

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  group = group,
  pattern = "*",
  callback = save,
})
