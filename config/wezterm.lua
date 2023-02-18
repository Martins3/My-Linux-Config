local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)


local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
local SOLID_LEFT_MOST = utf8.char(0x2588)
local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

local SUB_IDX = { "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₁₀",
  "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆", "₁₇", "₁₈", "₁₉", "₂₀" }

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local edge_background = "#121212"
  local background = "#4E4E4E"
  local foreground = "#1C1B19"
  local dim_foreground = "#3A3A3A"

  local title_prefix = ''
  if tab.is_active then
    background = "#FBB829"
    foreground = "#1C1B19"
    title_prefix = '🥝'
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
    { Text = ' ' },
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
    { mods = "CTRL|SHIFT", key = "-", action = "DecreaseFontSize" }, -- Ctrl-Shift-- (key with -)
    { mods = "CTRL|SHIFT", key = "+", action = "IncreaseFontSize" }, -- Ctrl-Shift-+ (key with =)
    { key = "j", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = 1 }) },
    { key = "k", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },
    {
      key = "LeftArrow",
      mods = 'CTRL|SHIFT',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = "RightArrow",
      mods = 'CTRL|SHIFT',
      action = wezterm.action.DisableDefaultAssignment,
    },
    { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.ShowLauncher },
  },
  adjust_window_size_when_changing_font_size = false,
  default_prog = { '/bin/sh', '-l', '-c', 'tmux attach || /usr/bin/env tmux' },
  -- default_prog = { '/bin/sh', '-l', '-c', 'zellij attach || /usr/bin/env zellij' },
  color_scheme = "Solarized Dark (base16)",
  font_size = 9.2,
  window_background_opacity = 0.8,
  font = wezterm.font_with_fallback {
    'FiraCode Nerd Font',
    { family = 'LXGW WenKai', scale = 1 },
  },
  use_fancy_tab_bar = false,
  launch_menu = {
    {
      label = 'M2',
      args = { 'ssh', '-b', '10.0.0.1', '-t', 'martins3@192.168.11.99', 'zellij attach || zellij' },
    },
    {
      args = { "zsh" },
    },
    {
      label = 'Arm Ubuntu Server',
      args = { 'ssh', '-t', 'martins3@192.168.26.81', 'tmux attach || tmux' },
    },
    {
      label = 'QEMU',
      args = { 'ssh', '-t', '-p5556', 'root@localhost', 'tmux attach || tmux' },
    },

    {
      label = 'zellij',
      args = { '/bin/sh', '-l', '-c', 'zellij attach || /usr/bin/env zellij' },
    },
    {
      label = 'tmux',
      args = { '/bin/sh', '-l', '-c', 'tmux attach || /usr/bin/env tmux' },
    },
  },

  colors = {
    tab_bar = {
      background = "#121212",
      new_tab = { bg_color = "#121212", fg_color = "#FCE8C3", intensity = "Bold" },
      new_tab_hover = { bg_color = "#121212", fg_color = "#FBB829", intensity = "Bold" },
      active_tab = { bg_color = "#121212", fg_color = "#FCE8C3" },
    }
  },
  window_background_gradient = {
    orientation = "Vertical",
    interpolation = "Linear",
    blend = "Rgb",
    colors = {
      "#121212",
      "#202020"
    }
  },
  tab_max_width = 60,
  freetype_load_target = "Normal",

  enable_kitty_graphics = true
}
