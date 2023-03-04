require("persisted").setup {
  autoload = true,
}

local group = vim.api.nvim_create_augroup("PersistedHooks", {})

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "PersistedSavePre",
  group = group,
  callback = function()
    vim.cmd "NvimTreeClose"
  end,
})
