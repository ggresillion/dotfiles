vim.pack.add({
	{ src = "https://github.com/nvim-neotest/neotest" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/antoinemadec/FixCursorHold.nvim" },
	{ src = "https://github.com/fredrikaverpil/neotest-golang", version = vim.version.range("*") },
})

local neotest = require("neotest")

neotest.setup({
	adapters = {
		require("neotest-golang")({
			-- runner = "gotestsum",
		}),
	},
})

vim.keymap.set("n", "<leader>tr", function()
	neotest.run.run()
end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tf", function()
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "Run current file" })
vim.keymap.set("n", "<leader>td", function()
	neotest.run.run({ strategy = "dap" })
end, { desc = "Debug current file" })
vim.keymap.set("n", "<leader>ts", function()
	neotest.run.stop()
end, { desc = "Stop nearest test" })
vim.keymap.set("n", "<leader>ta", function()
	neotest.run.attach()
end, { desc = "Attach to nearest test" })
