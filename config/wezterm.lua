local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

local function get_font_size()
  -- is popen supported?
  local popen_status, popen_result = pcall(io.popen, "")
  if popen_status and popen_result then
    popen_result:close()
    local raw_os_name = io.popen("lscpu |lscpu | grep -o  AMD-V", "r"):read("*l")
    -- amd 上使用的是一个 2k 32 寸 显示器
    if raw_os_name == "AMD-V" then
      return 12.2
      -- return 9.5 -- 内置屏幕
    end
  end

  -- intel 上使用的是一个 4k 27 寸 显示器
  return 19.2
end

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
local SOLID_LEFT_MOST = utf8.char(0x2588)
local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

local SUB_IDX = {
  "₁",
  "₂",
  "₃",
  "₄",
  "₅",
  "₆",
  "₇",
  "₈",
  "₉",
  "₁₀",
  "₁₁",
  "₁₂",
  "₁₃",
  "₁₄",
  "₁₅",
  "₁₆",
  "₁₇",
  "₁₈",
  "₁₉",
  "₂₀",
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local edge_background = "#121212"
  local background = "#4E4E4E"
  local foreground = "#1C1B19"
  local dim_foreground = "#3A3A3A"

  local title_prefix = ""
  if tab.is_active then
    background = "#FBB829"
    foreground = "#1C1B19"
    title_prefix = "🥝"
  elseif hover then
    background = "#FF8700"
    foreground = "#1C1B19"
  end

  local edge_foreground = background
  local process_name = tab.active_pane.foreground_process_name
  local exec_name = basename(process_name)
  local title_with_icon = exec_name
  local left_arrow = SOLID_LEFT_ARROW
  if tab.tab_index == 0 then
    left_arrow = SOLID_LEFT_MOST
  end

  if tab.tab_index == 0 then
    title_with_icon = "Martins3"
  end

  local id = SUB_IDX[tab.tab_index + 1]
  local title = " " .. title_prefix .. "" .. wezterm.truncate_right(title_with_icon, max_width - 6) .. " "

  return {
    { Attribute = { Intensity = "Bold" } },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = left_arrow },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = id },
    { Text = title },
    { Foreground = { Color = dim_foreground } },
    { Text = " " },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
    { Attribute = { Intensity = "Normal" } },
  }
end)

return {
  hide_tab_bar_if_only_one_tab = true,
  check_for_updates = false,
  keys = {
    { mods = "CTRL|SHIFT", key = "-",           action = "DecreaseFontSize" }, -- Ctrl-Shift-- (key with -)
    { mods = "CTRL|SHIFT", key = "+",           action = "IncreaseFontSize" }, -- Ctrl-Shift-+ (key with =)
    { key = "j",           mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = 1 }) },
    { key = "k",           mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },
    { key = "F7",          mods = "",           action = wezterm.action({ ActivateTabRelative = 1 }) },
    { key = "F8",          mods = "",           action = wezterm.action({ ActivateTabRelative = -1 }) },
    { key = "k",           mods = "CTRL",       action = wezterm.action({ ActivateTabRelative = 1 }) },
    -- { key = "j",           mods = "CTRL",       action = wezterm.action({ ActivateTabRelative = 1 }) },
    {
      key = "LeftArrow",
      mods = "CTRL|SHIFT",
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = "RightArrow",
      mods = "CTRL|SHIFT",
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = "g",
      mods = "CTRL|SHIFT",
      action = wezterm.action.SpawnCommandInNewTab({
        args = { "ssh", "-t", "martins3@10.0.1.1", "tmux attach || tmux" },
      }),
    },
    {
      key = "p",
      mods = "CTRL|SHIFT",
      action = wezterm.action.SpawnCommandInNewTab({
        args = { "ssh", "-t", "martins3@10.0.1.2", "tmux attach || tmux" },
      }),
      -- action = wezterm.action.ShowLauncher
    },
    {
      key = "m",
      mods = "CTRL|SHIFT",
      action = wezterm.action.SpawnCommandInNewTab({
        args = { "ssh", "-t", "martins3@10.0.0.1", '/bin/sh -l -c "tmux attach || tmux"' },
      }),
    },
    {
      key = "r",
      mods = "CTRL|SHIFT",
      action = wezterm.action.SpawnCommandInNewTab({
        args = { "ssh", "-t", "martins3@10.0.0.4", '/bin/sh -l -c "tmux attach || tmux"' },
      }),
    },
    {
      key = "i",
      mods = "CTRL|SHIFT",
      action = wezterm.action.SpawnCommandInNewTab({
        args = { "ssh", "-t", "martins3@192.168.19.55", "tmux attach || tmux" },
      }),
      -- action = wezterm.action.ShowLauncher
    },
    {
      key = "t",
      mods = "CTRL|SHIFT",
      action = wezterm.action.SpawnCommandInNewTab({
        args = { "zsh" },
      }),
    },
    {
      key = "z",
      mods = "CTRL|SHIFT",
      action = wezterm.action.SpawnCommandInNewTab({
        args = { "/bin/sh", "-l", "-c", "zellij attach || zellij" },
      }),
    },
    { key = "F8", mods = "", action = wezterm.action.ShowLauncher },
  },
  adjust_window_size_when_changing_font_size = false,
  default_prog = { "zsh" },
  -- default_prog = { "bash", "-l", "-c", "/usr/bin/env tmux attach || /usr/bin/env tmux" },
  -- default_prog = { '/bin/sh', '-l', '-c', 'zellij attach || /usr/bin/env zellij' },
  color_scheme = "Solarized (dark) (terminal.sexy)",
  font_size = get_font_size(),
  font = wezterm.font_with_fallback({
    "FiraCode Nerd Font",
    { family = "LXGW WenKai", scale = 1 },
  }),
  use_fancy_tab_bar = false,
  launch_menu = {
    {
      label = "Mi-wired",
      args = { "ssh", "-b", "10.0.0.1", "-t", "martins3@10.0.0.2", "zellij attach || zellij" },
    },
    {
      label = "M2",
      args = { "ssh", "-t", "martins3@192.168.11.99", "zellij attach || zellij" },
    },
    {
      label = "zellij",
      args = { "/bin/sh", "-l", "-c", "zellij attach || zellij" },
    },
    {
      label = "QEMU",
      args = { "ssh", "-t", "-p5556", "root@localhost", "zellij attach || zellij" },
    },
    {
      label = "bare",
      args = { "zsh" },
    },
  },
  colors = {
    tab_bar = {
      background = "#121212",
      new_tab = { bg_color = "#121212", fg_color = "#FCE8C3", intensity = "Bold" },
      new_tab_hover = { bg_color = "#121212", fg_color = "#FBB829", intensity = "Bold" },
      active_tab = { bg_color = "#121212", fg_color = "#FCE8C3" },
    },
  },
  -- 这两个配置是互斥的，前面那个是使用模糊颜色，后面使用图片
  -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  window_background_opacity = 1.0,
  window_background_gradient = {
    orientation = "Vertical",
    interpolation = "Linear",
    blend = "Rgb",
    colors = {
      "#121212",
      "#202020",
    },
  },
  -- ================================================================
  -- https://www.bing.com/th?id=OHR.WildGarlic_ZH-CN1869796625_UHD.jpg
  -- window_background_image = '/home/martins3/Pictures/BingWallpaper/20230323-WildGarlic_ZH-CN1869796625_UHD.jpg',
  -- window_background_image_hsb = {
  --   -- Darken the background image by reducing it to 1/3rd
  --   brightness = 0.04,
  --   -- You can adjust the hue by scaling its value.
  --   -- a multiplier of 1.0 leaves the value unchanged.
  --   hue = 1.0,
  --   -- You can adjust the saturation also.
  --   saturation = 1.0,
  -- },
  -- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  freetype_load_target = "Normal",
  enable_kitty_graphics = true,
  -- docker 那个图标没有没办法正常渲染，也许参考这里解决下吧
  -- https://wezfurlong.org/wezterm/config/fonts.html
  warn_about_missing_glyphs = false,
}
