return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		config = function()
			require("diffview").setup({
				use_icons = true, -- set to false if you want a minimalist UI
			})
		end,
		keys = {
			{
				"<leader>gda",
				"<cmd>DiffviewOpen origin/master...HEAD --imply-local<cr>",
				desc = "Diff vs origin/master",
			},
			{ "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (current file)" },
		},
	},
}
