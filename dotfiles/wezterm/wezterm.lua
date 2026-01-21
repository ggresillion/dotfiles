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
  max_fps = 120, -- keep this from main branch
}

local catppuccin_mocha = {
  color_scheme = "Catppuccin Mocha",
  colors = {
    ansi = {
      "#1e1e2e",
      "#f38ba8",
      "#a6e3a1",
      "#f9e2af",
      "#89b4fa",
      "#f5c2e7",
      "#94e2d5",
      "#bac2de",
    },
    brights = {
      "#45475a",
      "#f38ba8",
      "#a6e3a1",
      "#f9e2af",
      "#89b4fa",
      "#f5c2e7",
      "#94e2d5",
      "#a6adc8",
    },
  },
}

local catppuccin_latte = {
  color_scheme = "Catppuccin Latte",
  colors = {
    ansi = {
      "#eff1f5",
      "#d20f39",
      "#40a02b",
      "#df8e1d",
      "#1e66f5",
      "#ea76cb",
      "#179299",
      "#5c5f77",
    },
    brights = {
      "#bcc0cc",
      "#d20f39",
      "#40a02b",
      "#df8e1d",
      "#1e66f5",
      "#ea76cb",
      "#179299",
      "#6c6f85",
    },
  },
}

wezterm.on("window-config-reloaded", function(window)
  local appearance = window:get_appearance()
  local is_dark = appearance:find("Dark")
  if is_dark then
    window:set_config_overrides(catppuccin_mocha)
  else
    window:set_config_overrides(catppuccin_latte)
  end
end)

if wezterm.target_triple:find("darwin") then
  config.window_decorations = "RESIZE"
end

if wezterm.target_triple:find("windows") then
  config.default_domain = "WSL:archlinux"
end

return config
