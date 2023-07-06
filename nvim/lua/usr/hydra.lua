local Hydra = require("hydra")

-- 首先按 c a ，然后就可以使用 hjkl 来调整窗口大小

local hint = [[
 Adjust window size^^^^^^
 ^ ^ _k_ ^ ^
 _h_ ^ ^ _l_
 ^ ^ _j_ ^ ^   _<CR>_ or _<Esc>_ to exit
]]

Hydra({
  name = "Adjust Window Size",
  hint = hint,
  config = {
    color = "pink",
    invoke_on_body = true,
    hint = {
      border = "rounded",
    },
    on_enter = function()
      vim.o.virtualedit = "all"
    end,
  },
  mode = "n",
  body = "ca",
  heads = {
    { "k", "5<C-w>+" },
    { "j", "5<C-w>-", { desc = "j/k height" } },
    { "h", "5<C-w>>" },
    { "l", "5<C-w><", { desc = " h/l width" } },
    { "<Esc>", nil, { exit = true } },
    { "<CR>", nil, { exit = true } },
  },
})

-- 当想要修改一块代码的缩进的时候，使用 < 或者 > ，然后使用 . 来重复，这是 vim 的默认行为。
