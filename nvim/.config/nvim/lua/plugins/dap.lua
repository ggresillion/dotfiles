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
		config = function()
			local dap = require("dap")

			-- Function to scan for Go tests in the project
			local function scan_go_tests()
				local tests = {}
				local cwd = vim.fn.getcwd()

				-- Find all Go test files, with paths relative to cwd
				local command = "cd " .. vim.fn.escape(cwd, " ") .. " && find . -name '*_test.go' -type f"
				local test_files = vim.fn.systemlist(command)

				for _, file in ipairs(test_files) do
					-- file is like './internal/integrationtests/api_test.go'
					-- We need the absolute path to read the file
					local abs_file_path = cwd .. "/" .. file:gsub("^./", "")
					local lines = vim.fn.readfile(abs_file_path)
					for _, line in ipairs(lines) do
						local test_name, test_type
						local test_match = line:match("^func%s+(Test%w+)")
						local benchmark_match = line:match("^func%s+(Benchmark%w+)")
						local example_match = line:match("^func%s+(Example%w*)")

						if test_match then
							test_name = test_match
							test_type = "test"
						elseif benchmark_match then
							test_name = benchmark_match
							test_type = "benchmark"
						elseif example_match then
							test_name = example_match
							test_type = "example"
						end

						if test_name then
							local package_path = vim.fn.fnamemodify(file, ":h")
							table.insert(tests, {
								name = test_name,
								file = abs_file_path,
								package = package_path,
								display = package_path .. " :: " .. test_name,
								type = test_type,
							})
						end
					end
				end
				return tests
			end

			-- Function to debug a selected test
			local function debug_selected_test()
				local tests = scan_go_tests()

				if #tests == 0 then
					vim.notify("No tests found in the project", vim.log.levels.WARN)
					return
				end

				-- Create display options for vim.ui.select
				local display_options = {}
				for _, test in ipairs(tests) do
					table.insert(display_options, test.display)
				end

				-- Let user select a test
				vim.ui.select(display_options, {
					prompt = "Select test to debug:",
					format_item = function(item)
						return item
					end,
				}, function(choice, idx)
					if choice and idx then
						local selected_test = tests[idx]

						-- Start debugging with the selected test
						dap.run({
							type = "go",
							name = "Debug Selected Test",
							request = "launch",
							mode = "test",
							program = selected_test.package,
							args = {
								"-test.run",
								"^" .. selected_test.name .. "$",
							},
						})
					end
				end)
			end

			-- Store the function globally so we can access it from the keymap
			_G.debug_selected_test = debug_selected_test
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
			{
				"<leader>dT",
				function()
					_G.debug_selected_test()
				end,
				desc = "Debug Selected Test",
			},
		},
	},
}
