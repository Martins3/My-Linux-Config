require("persisted").setup({
  autoload = true,
})

local group = vim.api.nvim_create_augroup("PersistedHooks", {})

-- 不要让进入 vim 的时候光标在 nvim-tree 中，所以默认关闭 NvimTree
-- 此外，需要自动保存 bookmarks
vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "PersistedSavePre",
  group = group,
  callback = function()
    vim.cmd("NvimTreeClose")
    vim.cmd("BookmarkSave .vim-bookmarks")
  end,
})

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "PersistedLoadPost",
  group = group,
  callback = function()
    vim.cmd("BookmarkLoad .vim-bookmarks")
  end,
})
