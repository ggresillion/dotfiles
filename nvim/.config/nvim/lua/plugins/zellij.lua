vim.pack.add({
	{ src = "https://github.com/swaits/zellij-nav.nvim" },
})

require("zellij-nav").setup({})

local map = vim.keymap.set
map("n", "<C-h>", "<cmd>ZellijNavigateLeftTab<cr>", { silent = true, desc = "Navigate left / tab" })
map("n", "<C-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "Navigate down" })
map("n", "<C-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "Navigate up" })
map("n", "<C-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "Navigate right / tab" })
map("n", "<A-h>", "<cmd>ZellijNavigateLeftTab<cr>", { silent = true, desc = "Navigate left / tab" })
map("n", "<A-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "Navigate down" })
map("n", "<A-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "Navigate up" })
map("n", "<A-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "Navigate right / tab" })
