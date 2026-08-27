vim.pack.add({
	{ src = "https://github.com/mistweaverco/kulala.nvim" },
})

-- Silence kulala's one-off "Tree-sitter parser is ready!" notification.
local notify = vim.notify
vim.notify = function(msg, ...)
	if msg == "Tree-sitter parser is ready!" then
		return
	end
	return notify(msg, ...)
end

require("kulala").setup({
	global_keymaps = true,
	global_keymaps_prefix = "<leader>r",
	kulala_keymaps_prefix = "",
	-- <C-h>/<C-l> collide with pane navigation; use B/H/A/V/O/S/R/F to jump to a tab directly instead.
	kulala_keymaps = {
		["Previous tab"] = false,
		["Next tab"] = false,
	},
	ui = {
		max_response_size = 1048576,
	},
})
