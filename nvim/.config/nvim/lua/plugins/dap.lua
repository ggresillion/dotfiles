return {
	{
		"mfussenegger/nvim-dap",
		init = function()
			-- keybind to close the dap floating window
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dap-float",
				callback = function()
					vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
				end,
			})

			-- highlight signs
			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapLogPoint",
				{ text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
			)
			vim.fn.sign_define("DapStopped", {
				text = "",
				texthl = "DapStopped",
				linehl = "DapStopped",
				numhl = "DapStopped",
			})
		end,
		dependencies = {
			-- which key integration
			{
				"folke/which-key.nvim",
				optional = true,
				opts = {
					defaults = {
						["<leader>d"] = { name = "+debug" },
					},
				},
			},
			-- language specific
			{
				"leoluz/nvim-dap-go",
				opts = {},
			},
		},
		keys = {
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint Condition",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
				desc = "Go to line (no execute)",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>du",
				function()
					require("dap").up()
				end,
				desc = "Go up in the stack",
			},
			{
				"<leader>dd",
				function()
					require("dap").down()
				end,
				desc = "Go down in the stack",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle({ height = 16 })
				end,
				desc = "Toggle REPL",
			},
			{
				"<leader>dv",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Display the value of the variable under the cursor",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dx",
				function()
					require("dap").clear_breakpoints()
				end,
				desc = "Clear all breakpoints",
			},
		},
	},
}
