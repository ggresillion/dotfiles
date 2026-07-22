vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/tinted-theming/tinted-nvim" },
})

require("catppuccin").setup({
	transparent_background = true,
	float = {
		transparent = true,
	},
})

local theme_overrides = {
	["base16-catppuccin-mocha"] = "catppuccin-mocha",
	["base16-catppuccin-latte"] = "catppuccin-latte",
	["base24-catppuccin-mocha"] = "catppuccin-mocha",
	["base24-catppuccin-latte"] = "catppuccin-latte",
}

local function on_colorscheme(name)
	local override = theme_overrides[name]
	if override then
		vim.cmd("colorscheme " .. override)
	else
	end
end

require("tinted-nvim").setup({
	ui = {
		transparent = true,
	},
	highlights = {
		overrides = function(palette)
			return {
				LualineNormalA = { fg = palette.base00, bg = palette.base0B },
			}
		end,
	},
	selector = {
		enabled = true,
		mode = "file",
		watch = true,
	},
})

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function(ev)
		on_colorscheme(ev.match)
	end,
})

on_colorscheme(vim.g.colors_name or "")
