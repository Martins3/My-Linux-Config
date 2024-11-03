local Terminal = require("toggleterm.terminal").Terminal

-- TODO 这些重复的内容显然可以注册成函数
function _lazygit_toggle()
  local lazygit = Terminal:new({ cmd = "tig status", hidden = true, direction = "float" })
  lazygit:toggle()
end

function _ls_toggle()
  local ls = Terminal:new({ cmd = "tig " .. vim.api.nvim_buf_get_name(0), hidden = true, direction = "float" })
  ls:toggle()
  print(vim.api.nvim_buf_get_name(0))
end

function _ipython_toggle()
local ipython = Terminal:new({ cmd = "ipython", hidden = true, direction = "float" })
  ipython:toggle()
end

require("toggleterm").setup({
  shade_terminals = false,
  direction = "float",
  open_mapping = [[<c-t>]],
})

vim.api.nvim_set_keymap("n", "<space>gs", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>gl", "<cmd>lua _ls_toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>x", "<cmd>lua _ipython_toggle()<CR>", { noremap = true, silent = true })
