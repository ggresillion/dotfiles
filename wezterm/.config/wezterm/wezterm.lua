local wezterm = require 'wezterm'
local config = {
    color_scheme = 'Catppuccin Frappe',
    font = wezterm.font 'JetBrains Mono',
    font_size = 14,
    enable_tab_bar = false,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    use_ime = true,
    window_background_opacity = 0.90,
    macos_window_background_blur = 40,
}

return config
