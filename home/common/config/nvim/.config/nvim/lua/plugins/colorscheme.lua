vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/f-person/auto-dark-mode.nvim" },
	{ src = "https://github.com/tinted-theming/tinted-nvim" },
})

-- require("tinted-nvim").setup({
-- 	compile = true,
-- 	ui = {
-- 		transparent = true,
-- 	},
-- 	selector = {
-- 		enabled = true,
-- 	},
-- })

require("catppuccin").setup({
	transparent_background = true,
	flavour = "mocha",
	float = {
		transparent = true,
	},
})
vim.cmd("colorscheme catppuccin")

require("auto-dark-mode").setup({
	update_interval = 2000,
	set_dark_mode = function()
		vim.cmd("colorscheme catppuccin-mocha")
	end,
	set_light_mode = function()
		vim.cmd("colorscheme catppuccin-latte")
	end,
	fallback = "dark",
})
