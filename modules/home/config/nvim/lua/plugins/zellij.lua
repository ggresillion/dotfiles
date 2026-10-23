vim.pack.add({
	{ src = "https://github.com/mrjones2014/smart-splits.nvim" },
	{ src = "https://github.com/hiasr/vim-zellij-navigator.nvim" },
	{ src = "https://github.com/smart-splits-nvim/backend-zellij-lua" },
})

require("vim-zellij-navigator").setup()

local smart_splits = require("smart-splits")
require("smart-splits-backend-zellij-lua").setup({
	move_cursor = { pane_or_tab = true },
})
smart_splits.setup({
	-- Outside Zellij the backend fails detection and smart-splits warns on every start
	mux = vim.env.ZELLIJ and { backend = "smart-splits-backend-zellij-lua" } or nil,
})

local map = vim.keymap.set
map("n", "<C-h>", smart_splits.move_cursor_left, { silent = true, desc = "Navigate left" })
map("n", "<C-j>", smart_splits.move_cursor_down, { silent = true, desc = "Navigate down" })
map("n", "<C-k>", smart_splits.move_cursor_up, { silent = true, desc = "Navigate up" })
map("n", "<C-l>", smart_splits.move_cursor_right, { silent = true, desc = "Navigate right" })
map("n", "<A-h>", smart_splits.move_cursor_left, { silent = true, desc = "Navigate left" })
map("n", "<A-j>", smart_splits.move_cursor_down, { silent = true, desc = "Navigate down" })
map("n", "<A-k>", smart_splits.move_cursor_up, { silent = true, desc = "Navigate up" })
map("n", "<A-l>", smart_splits.move_cursor_right, { silent = true, desc = "Navigate right" })
