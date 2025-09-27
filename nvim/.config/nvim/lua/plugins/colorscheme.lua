vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/f-person/auto-dark-mode.nvim" },
})

require("catppuccin").setup({
	transparent_background = true,
	flavour = "mocha",
})
vim.cmd("colorscheme catppuccin")

require("auto-dark-mode").setup({
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
})
