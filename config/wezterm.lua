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
      key = "y", -- ctrl-shift-num 已经默认是跳转到 tab 了
      mods = 'CTRL|SHIFT',
      action = wezterm.action.SpawnCommandInNewTab {
        args = { 'ssh', '-t', 'martins3@192.168.26.81', 'tmux attach || /usr/bin/env tmux' },
      },
    },
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
  },
  adjust_window_size_when_changing_font_size = false,
  default_prog = { '/home/martins3/.nix-profile/bin/zsh', '-l', '-c', 'tmux attach || /usr/bin/env tmux' },
  color_scheme = "Solarized Dark (base16)",
  font_size = 9.2,
  window_background_opacity = 0.9,
  font = wezterm.font_with_fallback {
    'FiraCode Nerd Font',
    { family = 'LXGW WenKai', scale = 1 },
  },
  use_fancy_tab_bar = false
}
