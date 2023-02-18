require("toggleterm").setup {
  direction = 'float',
}

local Terminal = require('toggleterm.terminal').Terminal
local tig_status = Terminal:new({ cmd = "tig status", hidden = true })
local tig_log_file_status = Terminal:new({ cmd = "tig " .. vim.api.nvim_buf_get_name(0), hidden = true })
local tig_log_project_status = Terminal:new({ cmd = "tig", hidden = true })
local ipython = Terminal:new({ cmd = "ipython", hidden = true })

function _tig_status_toggle()
  tig_status:toggle()
end

function _tig_log_file_toggle()
  tig_log_file_status:toggle()
end

function _tig_log_project_toggle()
  tig_log_project_status:toggle()
end

function _ipython_toggle()
  ipython:toggle()
end

vim.api.nvim_set_keymap("n", "<Space>gs", "<cmd>lua _tig_status_toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Space>gl", "<cmd>lua _tig_log_file_toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Space>gL", "<cmd>lua _tig_log_project_toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Space>x", "<cmd>lua _ipython_toggle()<CR>", { noremap = true, silent = true })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-t>', [[<Cmd>ToggleTerm<CR>]], opts)
  vim.keymap.set('t', '<C-p>', [[<Cmd>1ToggleTerm<CR>]], opts)
  vim.keymap.set('t', '<C-n>', [[<Cmd>2ToggleTerm<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
