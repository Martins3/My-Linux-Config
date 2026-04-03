local isWindows = vim.fn.has('win32') == 1

if isWindows then
  local powershell_options = {
    shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
    shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }

  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end
end

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

function _qwen_toggle()
  local qwen = Terminal:new({ cmd = "qwen", hidden = true, direction = "float" })
  qwen:toggle()
end

require("toggleterm").setup({
  direction = "float",
  open_mapping = [[<c-t>]],
  persist_mode = false, -- 总是进入到 insert mode 中
  auto_scroll = false, -- 如果屏幕中出现新的内容，不要将屏幕滑动最下
})

vim.keymap.set("n", "<space>gs", _lazygit_toggle, { silent = true })
vim.keymap.set("n", "<space>gl", _ls_toggle, { silent = true })
vim.keymap.set("n", "<space>x", _ipython_toggle, { silent = true })
vim.keymap.set("n", "<space>e", _qwen_toggle, { silent = true })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)

  vim.keymap.set("t", "<c-s>", "<cmd>TermSelect<CR>", opts)
end

local toggleterm_group = vim.api.nvim_create_augroup("usr_toggleterm", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  group = toggleterm_group,
  pattern = "term://*",
  callback = function()
    set_terminal_keymaps()
  end,
})

function get_terminal()
  local m = vim.api.nvim_buf_get_name(0)
  print(string.match(m, '%d$'))
end

vim.keymap.set("n", "<c-s>", "<cmd>TermSelect<CR>", { silent = true })
