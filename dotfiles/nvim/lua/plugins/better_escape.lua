vim.pack.add({
	{ src = "https://github.com/max397574/better-escape.nvim" },
})

require("better_escape").setup({
	default_mappings = false,
	mappings = {
		i = {
			j = { k = "<Esc>", j = "<Esc>" },
			k = { j = "<Esc>" },
		},
	},
})
