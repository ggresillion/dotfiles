vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.icons" },
})

require("mini.icons").setup({})

require("oil").setup({
	keymaps = {
		["<C-h>"] = false,
		["<C-l>"] = false,
	},
})

vim.keymap.set("n", "<leader>e", function()
	require("oil").open()
end, { desc = "Open File Tree" })
