local wezterm = require 'wezterm'

local config = {
    font = wezterm.font "JetBrains Mono",
    font_size = 14,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    show_tabs_in_tab_bar = false,
    show_new_tab_button_in_tab_bar = false,
    window_decorations = "INTEGRATED_BUTTONS|RESIZE",
    window_background_opacity = 0.5,
    macos_window_background_blur = 50,
    window_close_confirmation = "NeverPrompt",
}

wezterm.on("window-config-reloaded", function(window, pane)
  local appearance = window:get_appearance()
  local is_dark = appearance:find("Dark")
  if is_dark then
    window:set_config_overrides({
      color_scheme = "Catppuccin Mocha",
      window_frame = {
        active_titlebar_bg = "rgba(30, 30, 46, 0.5)",
        inactive_titlebar_bg = "rgba(30, 30, 46, 0.5)",
      },
    })
  else
    window:set_config_overrides({
      color_scheme = "Catppuccin Latte",
      window_frame = {
        active_titlebar_bg = "rgba(239, 241, 245, 0.5)",
        inactive_titlebar_bg = "rgba(239, 241, 245, 0.5)",
      },
    })
  end
end)

return config
