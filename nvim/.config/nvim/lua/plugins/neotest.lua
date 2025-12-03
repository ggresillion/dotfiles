local project_config_file = vim.fn.getcwd() .. "/.test_config.json"
local temp_file = vim.fn.stdpath("data") .. "/test_current_config.json"

local function read_file(path)
	local fd = vim.loop.fs_open(path, "r", 438) -- 438 = 0666
	if not fd then
		return nil
	end
	local stat = vim.loop.fs_fstat(fd)
	if not stat then
		return nil
	end
	local data = vim.loop.fs_read(fd, stat.size, 0)
	vim.loop.fs_close(fd)
	return data
end

local function write_file(path, data)
	local fd = vim.loop.fs_open(path, "w", 438)
	if not fd then
		return
	end
	vim.loop.fs_write(fd, data, 0)
	vim.loop.fs_close(fd)
end

local function load_project_config()
	local data = read_file(project_config_file)
	if data then
		local ok, tbl = pcall(vim.fn.json_decode, data)
		if ok then
			return tbl
		end
	end
	return { configs = {} }
end

local function load_current()
	local data = read_file(temp_file)
	if data then
		local ok, tbl = pcall(vim.fn.json_decode, data)
		if ok then
			return tbl.current
		end
	end
	-- default to first config
	local proj_cfg = load_project_config()
	local keys = vim.tbl_keys(proj_cfg.configs)
	return keys[1]
end

local function save_current(name)
	write_file(temp_file, vim.fn.json_encode({ current = name }))
end

local function get_current_env()
	local proj_cfg = load_project_config()
	local current = load_current()
	if current and proj_cfg.configs[current] then
		return proj_cfg.configs[current]
	end
	return {}
end

local function switch_config()
	local proj_cfg = load_project_config()
	local keys = vim.tbl_keys(proj_cfg.configs)
	if #keys == 0 then
		vim.notify("No test configurations found!", vim.log.levels.WARN)
		return
	end

	vim.ui.select(keys, {
		prompt = "Select Neotest configuration:",
		format_item = function(item)
			return item
		end,
	}, function(choice)
		if choice then
			save_current(choice)
			vim.notify("Neotest config switched to: " .. choice)
		end
	end)
end

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
			env = get_current_env,
			warn_test_name_dupes = false,
		}),
	},
})

local keymap = vim.keymap.set

-- Switch active configuration
keymap("n", "<leader>tc", switch_config, { desc = "Switch neotest config" })

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
