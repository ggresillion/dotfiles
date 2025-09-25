return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			transparent_background = true,
			flavour = "mocha",
		},
		init = function()
			vim.cmd("colorscheme catppuccin")
		end,
	},
	{
		"f-person/auto-dark-mode.nvim",
		opts = {
			update_interval = 2000,
			set_dark_mode = function()
				vim.opt.background = "dark"
				vim.cmd("colorscheme catppuccin-mocha")
			end,
			set_light_mode = function()
				vim.opt.background = "light"
				vim.cmd("colorscheme catppuccin-latte")
			end,
			fallback = "dark",
		},
	},
}
