local wezterm = require("wezterm")

local function read_file(path)
	local f = io.open(path, "r")
	if not f then return nil end
	local s = f:read("*l")
	f:close()
	return s
end

local config = {
	enable_wayland = false,
	color_scheme = "Noctalia",
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
	keys = {
		{ key = "q", mods = "CMD",       action = wezterm.action.CloseCurrentTab({ confirm = false }) },
		{ key = "w", mods = "CMD|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
	},
	max_fps = 240,
}

wezterm.on("window-focus-changed", function(window)
	window:set_config_overrides({
		window_background_opacity = window:is_focused() and 0.8 or 0.5,
	})
end)

if wezterm.target_triple:find("darwin") then
	config.window_decorations = "RESIZE"
end

if wezterm.target_triple:find("windows") then
	config.default_domain = "WSL:archlinux"
end

return config
