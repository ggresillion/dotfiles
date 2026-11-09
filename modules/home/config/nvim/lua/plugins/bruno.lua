vim.pack.add({
	{ src = "https://github.com/jugarpeupv/bruno.nvim" },
})

require("bruno").setup({})

local keymap = vim.keymap.set

keymap("n", "<leader>br", "<cmd>BrunoRun<cr>", { desc = "Run Bruno request" })
keymap("n", "<leader>bR", "<cmd>BrunoReplay<cr>", { desc = "Replay last Bruno request" })
keymap("n", "<leader>bo", "<cmd>BrunoToggle<cr>", { desc = "Toggle Bruno workbench" })
keymap("n", "<leader>be", "<cmd>BrunoEnv<cr>", { desc = "Select Bruno env" })
keymap("n", "<leader>bs", "<cmd>BrunoRequests<cr>", { desc = "Pick Bruno request" })
keymap("n", "<leader>bc", "<cmd>BrunoCopyCurl<cr>", { desc = "Copy Bruno request as curl" })
