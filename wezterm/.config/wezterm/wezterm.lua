local wezterm = require("wezterm")

local config = {
	font = wezterm.font("JetBrains Mono"),
	font_size = 14,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	enable_tab_bar = false,
	window_decorations = "INTEGRATED_BUTTONS|RESIZE|MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR",
	window_close_confirmation = "NeverPrompt",
}

wezterm.on("window-config-reloaded", function(window, pane)
	local appearance = window:get_appearance()
	local is_dark = appearance:find("Dark")
	if is_dark then
		window:set_config_overrides({
			color_scheme = "Catppuccin Mocha",
		})
	else
		window:set_config_overrides({
			color_scheme = "Catppuccin Latte",
		})
	end
end)

return config
