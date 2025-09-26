vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/leoluz/nvim-dap-go" },
})

local function setup_dap_signs()
	local signs = {
		DapBreakpoint = { text = "", texthl = "DapBreakpoint" },
		DapBreakpointCondition = { text = "ﳁ", texthl = "DapBreakpoint" },
		DapBreakpointRejected = { text = "", texthl = "DapBreakpoint" },
		DapLogPoint = { text = "", texthl = "DapLogPoint" },
		DapStopped = { text = "", texthl = "DapStopped" },
	}
	for name, sign in pairs(signs) do
		vim.fn.sign_define(name, {
			text = sign.text,
			texthl = sign.texthl,
			linehl = name,
			numhl = name,
		})
	end
end

local function scan_go_tests()
	local tests = {}
	local cwd = vim.fn.getcwd()
	local command = "cd " .. vim.fn.escape(cwd, " ") .. " && find . -name '*_test.go' -type f"
	local test_files = vim.fn.systemlist(command)
	for _, file in ipairs(test_files) do
		local abs_file_path = cwd .. "/" .. file:gsub("^./", "")
		local lines = vim.fn.readfile(abs_file_path)
		for _, line in ipairs(lines) do
			local test_patterns = {
				{ pattern = "^func%s+(Test%w+)", type = "test" },
				{ pattern = "^func%s+(Benchmark%w+)", type = "benchmark" },
				{ pattern = "^func%s+(Example%w*)", type = "example" },
			}
			for _, test_pattern in ipairs(test_patterns) do
				local test_name = line:match(test_pattern.pattern)
				if test_name then
					local package_path = vim.fn.fnamemodify(file, ":h")
					table.insert(tests, {
						name = test_name,
						file = abs_file_path,
						package = package_path,
						display = package_path .. " :: " .. test_name,
						type = test_pattern.type,
					})
					break
				end
			end
		end
	end
	return tests
end

local function debug_selected_test()
	local tests = scan_go_tests()
	if #tests == 0 then
		vim.notify("No tests found in the project", vim.log.levels.WARN)
		return
	end
	local display_options = vim.tbl_map(function(test)
		return test.display
	end, tests)
	vim.ui.select(display_options, { prompt = "Select test to debug:" }, function(choice, idx)
		if choice and idx then
			local selected_test = tests[idx]
			require("dap").run({
				type = "go",
				name = "Debug Selected Test",
				request = "launch",
				mode = "test",
				program = selected_test.package,
				args = { "-test.run", "^" .. selected_test.name .. "$" },
			})
		end
	end)
end

local function setup_js_adapters()
	local dap = require("dap")
	for _, adapter in pairs({ "pwa-node", "pwa-chrome" }) do
		dap.adapters[adapter] = {
			type = "server",
			host = "::1",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug-adapter",
				args = { "${port}" },
			},
		}
	end
end

local function setup_js_configurations()
	local dap = require("dap")
	local languages = { "typescript", "javascript", "javascriptreact", "typescriptreact" }
	for _, language in ipairs(languages) do
		dap.configurations[language] = {
			{
				type = "pwa-chrome",
				name = "Launch Chrome to debug client",
				request = "launch",
				url = "http://localhost:3000",
				sourceMaps = true,
				protocol = "inspector",
				port = 9222,
				webRoot = "${workspaceFolder}",
				skipFiles = { "**/node_modules/**/*", "**/@vite/*" },
			},
		}
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "dap-float",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
	end,
})

setup_dap_signs()
_G.debug_selected_test = debug_selected_test
setup_js_adapters()
setup_js_configurations()

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
map("n", "<leader>dT", function()
	_G.debug_selected_test()
end, { desc = "Debug Selected Test" })
