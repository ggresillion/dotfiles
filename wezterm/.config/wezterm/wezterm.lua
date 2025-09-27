local wezterm = require 'wezterm'

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Mocha'
  else
    return 'Catppuccin Latte'
  end
end

local config = {
  font = wezterm.font 'JetBrains Mono',
  font_size = 14,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  enable_tab_bar = false,
  -- window_decorations = "INTEGRATED_BUTTONS|RESIZE",
  window_close_confirmation = "NeverPrompt",
  default_domain = "WSL:archlinux",
}

if wezterm.target_triple:find("darwin") then
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE|MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR"
end

if wezterm.running_under_wsl() then
  config.color_scheme = "Catppuccin Mocha"
else
  local appearance = 'Dark'
  if wezterm.gui then
    appearance = wezterm.gui.get_appearance()
  end
  config.color_scheme = scheme_for_appearance(appearance)
end

return config
