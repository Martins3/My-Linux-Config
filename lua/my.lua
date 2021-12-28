-- 主要的参考资料
-- 似乎，使用 nvim-notify 作为阅读卡片是更加好用的呀
-- https://github.com/rcarriga/nvim-notify
-- https://github.com/jacobsimpson/nvim-example-lua-plugin
-- https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup
local Popup = require("nui.popup")

local popup = Popup({
  position = "50%",
  size = {
    width = 80,
    height = 40,
  },
  enter = true,
  focusable = true,
  zindex = 50,
  relative = "editor",
  border = {
    highlight = "FloatBorder",
    padding = {
      top = 2,
      bottom = 2,
      left = 3,
      right = 3,
    },
    style = "rounded",
    text = {
      top = " I am top title ",
      top_align = "center",
      bottom = "I am bottom title",
      bottom_align = "left",
    },
  },
  buf_options = {
    modifiable = true,
    readonly = true,
  },
  win_options = {
    winblend = 10,
    winhighlight = "Normal:Normal",
  },
})

local function exit()
  print("ESC pressed in Normal mode!")
  popup:unmount()
end

local function local_lua_function()
  popup:mount()
  popup:map("n", "q", exit, { noremap = true })
end

return {
    local_lua_function = local_lua_function,
}
