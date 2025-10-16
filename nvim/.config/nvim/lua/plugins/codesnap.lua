vim.pack.add({
	{ src = "https://github.com/mistricky/codesnap.nvim" },
})

require("codesnap").setup({
	save_path = "~/Pictures",
	has_breadcrumbs = true,
	has_line_number = true,
	bg_theme = "grape",
	watermark = "",
})

local map = vim.keymap.set
map("x", "<leader>cc", "<cmd>CodeSnap<cr>", { desc = "Save selected code snapshot into clipboard" })
map("x", "<leader>cs", "<cmd>CodeSnapSave<cr>", { desc = "Save selected code snapshot in ~/Pictures" })
