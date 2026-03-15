local wezterm = require("wezterm")

local config = {
  enable_wayland = false,
  font = wezterm.font("JetBrains Mono"),
  font_size = 15,
  window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4,
  },
  enable_tab_bar = false,
  window_close_confirmation = "NeverPrompt",
  window_background_opacity = 0.8,
  macos_window_background_blur = 40,
  window_decorations = "INTEGRATED_BUTTONS|RESIZE",
  max_fps = 120,
}

if wezterm.target_triple:find("darwin") then
  config.window_decorations = "RESIZE"
end

if wezterm.target_triple:find("windows") then
  config.default_domain = "WSL:archlinux"
end

config.color_scheme = "Noctalia"

return config
