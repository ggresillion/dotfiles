vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
})

require("lualine").setup({
	options = {
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			{
				"filename",
				path = 1,
			},
		},
		lualine_d = {
			{
				function()
					return require("dap").status()
				end,
				icon = { "", color = { fg = "#e7c664" } },
				cond = function()
					if not package.loaded.dap then
						return false
					end
					local session = require("dap").session()
					return session ~= nil
				end,
			},
		},
		lualine_x = { "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})
