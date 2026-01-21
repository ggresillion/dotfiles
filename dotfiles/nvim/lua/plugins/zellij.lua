vim.pack.add({
	{ src = "https://github.com/mrjones2014/smart-splits.nvim" },
})

local smart_splits = require("smart-splits")
smart_splits.setup({
	zellij_move_focus_or_tab = true,
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
