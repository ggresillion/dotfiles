vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/romek-codes/bruno.nvim" },
})

require("bruno").setup({
	collection_paths = {
		{ name = "Projects", path = vim.fn.expand("~/Projects") },
	},
	picker = "snacks",
	show_formatted_output = true,
	suppress_formatting_errors = false,
})

local keymap = vim.keymap.set

keymap("n", "<leader>br", "<cmd>BrunoRun<cr>", { desc = "Run Bruno request" })
keymap("n", "<leader>be", "<cmd>BrunoEnv<cr>", { desc = "Select Bruno env" })
keymap("n", "<leader>bs", "<cmd>BrunoSearch<cr>", { desc = "Search Bruno requests" })
keymap("n", "<leader>bf", "<cmd>BrunoToggleFormat<cr>", { desc = "Toggle Bruno output format" })
