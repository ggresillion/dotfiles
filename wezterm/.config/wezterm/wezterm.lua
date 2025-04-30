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
    window_frame = {
        active_titlebar_bg = "rgba(48, 52, 70, 0.8)",
        inactive_titlebar_bg = "rgba(48, 52, 70, 0.8)",
    },
    window_background_opacity = 0.8,
    macos_window_background_blur = 10,
}

wezterm.on("window-config-reloaded", function(window, pane)
    local appearance = window:get_appearance()
    local is_dark = appearance:find("Dark")
    if is_dark then
        window:set_config_overrides({ color_scheme = "Catppuccin Frappe" })
    else
        window:set_config_overrides({ color_scheme = "Catppuccin Latte" })
    end
end)

if wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin" then
    config.keys = {
        {
            key = "n",
            mods = "OPT",
            action = wezterm.action.SendString("~"),
        },
        {
            key = "é",
            mods = "ALT",
            action = wezterm.action.SendString("~"),
        },
    }
end

return config
