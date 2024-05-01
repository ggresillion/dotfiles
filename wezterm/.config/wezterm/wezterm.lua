local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Catppuccin Frappe'
config.font = wezterm.font 'JetBrains Mono'
config.enable_tab_bar = false
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

return config
