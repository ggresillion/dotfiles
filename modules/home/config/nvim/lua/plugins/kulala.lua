vim.pack.add({
	{ src = "https://github.com/mistweaverco/kulala.nvim" },
})

require("kulala").setup({
	global_keymaps = true,
	global_keymaps_prefix = "<leader>r",
	kulala_keymaps_prefix = "",
	-- <C-h>/<C-l> collide with pane navigation; use B/H/A/V/O/S/R/F to jump to a tab directly instead.
	kulala_keymaps = {
		["Previous tab"] = false,
		["Next tab"] = false,
	},
	ui = {
		max_response_size = 1048576,
	},
})
