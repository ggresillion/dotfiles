local wezterm = require("wezterm")

function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Mocha'
  else
    return 'Catppuccin Latte'
  end
end

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
  color_scheme = scheme_for_appearance(get_appearance()),
}

local toggle_system_appearance = wezterm.config_dir .. "/toggle_system_appearance.sh"

return config
