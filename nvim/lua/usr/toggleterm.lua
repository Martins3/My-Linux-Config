require("toggleterm").setup {
  direction = 'float',
}

local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({ cmd = "tig status", hidden = true })

function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<Space>gs", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-t>', [[<Cmd>ToggleTerm<CR>]], opts)
  vim.keymap.set('t', '<C-p>', [[<Cmd>1ToggleTerm<CR>]], opts)
  vim.keymap.set('t', '<C-n>', [[<Cmd>2ToggleTerm<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
