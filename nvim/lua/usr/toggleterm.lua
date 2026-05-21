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
local python = require("usr.python")

local function toggle_float_terminal(cmd)
  Terminal:new({
    cmd = cmd,
    hidden = true,
    direction = "float",
  }):toggle()
end

local function lazygit_toggle()
  toggle_float_terminal("tig status")
end

local function ls_toggle()
  toggle_float_terminal("tig " .. vim.api.nvim_buf_get_name(0))
end

local function ipython_toggle()
  toggle_float_terminal(python.ipython_command())
end

local function pytest_file_toggle()
  toggle_float_terminal(python.pytest_command())
end

local function pytest_nearest_toggle()
  toggle_float_terminal(python.pytest_command(python.current_test_target()))
end

local function pytest_project_toggle()
  local root = python.project_root(0)
  toggle_float_terminal("cd " .. vim.fn.shellescape(root) .. " && " .. python.pytest_cmd(root))
end

local function qwen_toggle()
  toggle_float_terminal("qwen")
end

require("toggleterm").setup({
  direction = "float",
  open_mapping = [[<c-t>]],
  persist_mode = false, -- 总是进入到 insert mode 中
  auto_scroll = false, -- 如果屏幕中出现新的内容，不要将屏幕滑动最下
})

vim.keymap.set("n", "<space>gs", lazygit_toggle, { silent = true })
vim.keymap.set("n", "<space>gl", ls_toggle, { silent = true })
vim.keymap.set("n", "<space>x", ipython_toggle, { silent = true })
vim.keymap.set("n", "<space>e", qwen_toggle, { silent = true })
vim.keymap.set("n", "<space>lt", pytest_file_toggle, { silent = true, desc = "pytest current file" })
vim.keymap.set("n", "<space>lT", pytest_nearest_toggle, { silent = true, desc = "pytest nearest test" })
vim.keymap.set("n", "<space>lp", pytest_project_toggle, { silent = true, desc = "pytest project" })

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
