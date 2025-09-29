local wezterm = require("wezterm")

local config = {
	font = wezterm.font("JetBrains Mono"),
	font_size = 15,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	enable_tab_bar = false,
	window_decorations = "RESIZE",
	window_close_confirmation = "NeverPrompt",
	window_background_opacity = 0.8,
	macos_window_background_blur = 20,
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.enable_tab_bar = true
	config.use_fancy_tab_bar = true
	config.show_tabs_in_tab_bar = false
	config.show_new_tab_button_in_tab_bar = false
	config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
	config.default_domain = "WSL:archlinux"
end

wezterm.on("window-config-reloaded", function(window, pane)
	local appearance = window:get_appearance()
	local is_dark = appearance:find("Dark")
	if is_dark then
		window:set_config_overrides({
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
		})
	else
		window:set_config_overrides({
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
		})
	end
end)

return config
