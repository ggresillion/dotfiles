vim.pack.add({
	{ src = "https://github.com/coder/claudecode.nvim" },
})

-- Claude Code runs in its own terminal pane and attaches with `/ide` or `claude --ide`
require("claudecode").setup({
	terminal = {
		provider = "none",
	},
})

local map = vim.keymap.set
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept Claude diff" })
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny Claude diff" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add buffer to Claude" })
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude" })
map("n", "<leader>aS", "<cmd>ClaudeCodeStatus<cr>", { desc = "Claude connection status" })
