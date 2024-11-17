local Terminal = require("toggleterm.terminal").Terminal

-- TODO 这些重复的内容显然可以注册成函数
function _lazygit_toggle()
  local lazygit = Terminal:new({
    cmd = "tig status",
    hidden = true,
    direction = "float",
  })
  lazygit:toggle()
end

function _ls_toggle()
  local ls = Terminal:new({ cmd = "tig " .. vim.api.nvim_buf_get_name(0), hidden = true, direction = "float" })
  ls:toggle()
end

function _ipython_toggle()
  local ipython = Terminal:new({ cmd = "ipython", hidden = true, direction = "float" })
  ipython:toggle()
end

require("toggleterm").setup({
  direction = "float",
  open_mapping = [[<c-t>]],
  persist_mode = false, -- 总是进入到 insert mode 中
})

vim.api.nvim_set_keymap("n", "<space>gs", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>gl", "<cmd>lua _ls_toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>x", "<cmd>lua _ipython_toggle()<CR>", { noremap = true, silent = true })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)

  vim.keymap.set("t", "<c-s>", "<cmd>TermSelect<CR>", opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

function get_terminal()
  local m = vim.api.nvim_buf_get_name(0)
  print(string.match(m, '%d$'))
end

vim.api.nvim_set_keymap("n", "<c-s>", "<cmd>TermSelect<CR>",
  { noremap = true, silent = true })
