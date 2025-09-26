vim.pack.add({
	{ src = "https://github.com/mistweaverco/kulala.nvim" },
})

require("kulala").setup({
	global_keymaps = true,
	global_keymaps_prefix = "<leader>r",
	kulala_keymaps_prefix = "",
	ui = {
		max_response_size = 124000,
	},
})
