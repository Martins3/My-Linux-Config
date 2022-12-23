local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return {
  hide_tab_bar_if_only_one_tab = true,
  check_for_updates = false,
  keys = {
    { mods = "CTRL|SHIFT", key = "-", action = "DecreaseFontSize" }, -- Ctrl-Shift-- (key with -)
    { mods = "CTRL|SHIFT", key = "+", action = "IncreaseFontSize" }, -- Ctrl-Shift-+ (key with =)
    {
      key = "y", -- @todo 为什么不能切换为 2 ?
      mods = 'CTRL|SHIFT',
      action = wezterm.action.SpawnCommandInNewTab {
        args = { 'ssh', '-t', 'martins3@192.168.26.81', 'tmux attach || /usr/bin/env tmux' },
      },
    },
    {
      key = "u",
      mods = 'CTRL|SHIFT',
      action = wezterm.action.SpawnCommandInNewTab {
        args = { 'htop' },
      },
    },
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
  },
  adjust_window_size_when_changing_font_size = false,
  default_prog = { '/home/martins3/.nix-profile/bin/zsh', '-l', '-c', 'tmux attach || /usr/bin/env tmux' },
  color_scheme = "Solarized Dark (base16)",
  font_size = 9.2,
  window_background_opacity = 0.9,
  font = wezterm.font_with_fallback {
    'FiraCode Nerd Font',
    { family = 'LXGW WenKai', scale = 1, weight = 'Bold', },
  },
  -- @todo 不知道为什么，重启之后 wezterm 无法输入中文了
  -- @todo super + number 老是被 gnome 截断，尝试了一下，失败了
  -- @todo tab 的样式也许可以调整一下
}
