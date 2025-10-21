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
			runner = "gotestsum",
		}),
	},
})

local keymap = vim.keymap.set

-- Run nearest test
keymap("n", "<leader>tr", function()
	neotest.run.run()
end, { desc = "Run nearest test" })

-- Run current file
keymap("n", "<leader>tf", function()
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "Run current file" })

-- Run project / directory tests
keymap("n", "<leader>tp", function()
	neotest.run.run(vim.loop.cwd())
end, { desc = "Run all tests in project" })

-- Debug nearest test
keymap("n", "<leader>td", function()
	neotest.run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })

-- Stop nearest test
keymap("n", "<leader>ts", function()
	neotest.run.stop()
end, { desc = "Stop nearest test" })

-- Attach to nearest test (for async debugging)
keymap("n", "<leader>ta", function()
	neotest.run.attach()
end, { desc = "Attach to nearest test" })

-- Toggle summary window
keymap("n", "<leader>tt", function()
	neotest.summary.toggle()
end, { desc = "Toggle test summary" })

-- Jump to next failed test
keymap("n", "]f", function()
	neotest.jump.next({ status = "failed" })
end, { desc = "Jump to next failed test" })

-- Jump to previous failed test
keymap("n", "[f", function()
	neotest.jump.prev({ status = "failed" })
end, { desc = "Jump to previous failed test" })

-- Run last test again
keymap("n", "<leader>tl", function()
	neotest.run.run_last()
end, { desc = "Run last test again" })

-- Toggle test output (floating window)
keymap("n", "<leader>to", function()
	neotest.output_panel.toggle()
end, { desc = "Toggle test output panel" })

-- Show output of the nearest test in floating window
keymap("n", "<leader>tn", function()
	neotest.output.open({ enter = true })
end, { desc = "Show output for nearest test" })
