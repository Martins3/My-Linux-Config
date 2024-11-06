-- 也许换成这个吧: https://github.com/rebelot/terminal.nvim 
-- 感觉不好用啊
require("terminal").setup(
  {
    layout = { open_cmd = "float" },
    cmd = { vim.o.shell },
    autoclose = true,
  }
)

local term_map = require("terminal.mappings")
-- vim.keymap.set({ "n", "x" }, "<leader>ts", term_map.operator_send, { expr = true })
vim.keymap.set("n", 'x', "<c-t>", term_map.toggle)
-- vim.keymap.set("n", "<c-t>", term_map.toggle({ open_cmd = "enew" }))
vim.keymap.set({"n", 'x'}, "<c-n>", term_map.cycle_next)
vim.keymap.set({"n", 'x'}, "<c-p>", term_map.cycle_prev)

vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
  callback = function(args)
    if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
      vim.cmd("startinsert")
    end
  end,
})
