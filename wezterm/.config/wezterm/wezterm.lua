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
    -- background = {
    --     {
    --         source = {
    --             File = wezterm.config_dir .. '/background.jpg',
    --         },
    --         opacity = 1.0,
    --     },
    --     {
    --         source = { Color = "#2a4e62" },
    --         width = "100%",
    --         height = "100%",
    --         opacity = 0.9,
    --     },
    -- }
}

if wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin" then
    config.keys = {
        { key = "n", mods = "OPT", action = wezterm.action { SendString = "~" } },
    }
end

return config
