require("notify").setup({
  -- Animation style (see below for details)
  stages = "fade_in_slide_out",

  -- Function called when a new window is opened, use for changing win settings/config
  on_open = nil,

  -- Function called when a window is closed
  on_close = nil,

  -- Render function for notifications. See notify-render()
  render = "default",

  -- Default timeout for notifications
  timeout = 5000,

  -- For stages that change opacity this is treated as the highlight behind the window
  -- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
  background_colour = "Normal",

  -- Minimum width for notification windows
  minimum_width = 50,

  -- Icons for the different levels
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
  },
})

local notify = require("notify")
local t = os.date ("*t") --> produces a table like this:
local time_left = 30 - t.min % 30
local function min(m)
  return m * 60 * 1000
end

local function drink_water()
		local timer = vim.loop.new_timer()
    local l = min(time_left)
		timer:start(0, min(30), function()
-- require("notify")("My super important message")
		end)
end
drink_water()
