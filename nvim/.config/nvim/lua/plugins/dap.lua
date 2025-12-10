vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/leoluz/nvim-dap-go" },
	{ src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
})

require("dap-go").setup()

local dap = require("dap")

dap.adapters["pwa-chrome"] = {
	type = "server",
	host = "::1",
	port = "${port}",
	executable = {
		command = "js-debug-adapter",
		args = {
			"${port}",
		},
	},
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = "dap-float",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
	end,
})

vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "●", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapBreakpointCondition",
	{ text = "⦿", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapBreakpointRejected",
	{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapLogPoint",
	{ text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

local map = vim.keymap.set
map("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
map("n", "<leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Breakpoint Condition" })
map("n", "<leader>dx", function()
	require("dap").clear_breakpoints()
end, { desc = "Clear all breakpoints" })
map("n", "<leader>dc", function()
	require("dap").continue()
end, { desc = "Continue" })
map("n", "<leader>dl", function()
	require("dap").run_last()
end, { desc = "Run Last" })
map("n", "<leader>dt", function()
	require("dap").terminate()
end, { desc = "Terminate" })
map("n", "<leader>dC", function()
	require("dap").run_to_cursor()
end, { desc = "Run to Cursor" })
map("n", "<leader>dg", function()
	require("dap").goto_()
end, { desc = "Go to line (no execute)" })
map("n", "<leader>di", function()
	require("dap").step_into()
end, { desc = "Step Into" })
map("n", "<leader>do", function()
	require("dap").step_over()
end, { desc = "Step Over" })
map("n", "<leader>dO", function()
	require("dap").step_out()
end, { desc = "Step Out" })
map("n", "<leader>du", function()
	require("dap").up()
end, { desc = "Go up in the stack" })
map("n", "<leader>dd", function()
	require("dap").down()
end, { desc = "Go down in the stack" })
map("n", "<leader>dr", function()
	require("dap").repl.toggle({ height = 16 })
end, { desc = "Toggle REPL" })
map("n", "<leader>dv", function()
	require("dap.ui.widgets").hover()
end, { desc = "Display variable value" })
map("n", "<leader>dp", function()
	require("dap.ui.widgets").preview()
end, { desc = "Preview variable value" })
