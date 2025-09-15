return {
	"swaits/zellij-nav.nvim",
	event = "VeryLazy",
	keys = {
		{ "<C-h>", "<cmd>ZellijNavigateLeftTab<cr>", { silent = true, desc = "Navigate left / tab" } },
		{ "<C-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "Navigate down" } },
		{ "<C-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "Navigate up" } },
		{ "<C-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "Navigate right / tab" } },
		{ "<A-h>", "<cmd>ZellijNavigateLeftTab<cr>", { silent = true, desc = "Navigate left / tab" } },
		{ "<A-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "Navigate down" } },
		{ "<A-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "Navigate up" } },
		{ "<A-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "Navigate right / tab" } },
	},
	opts = {},
}
