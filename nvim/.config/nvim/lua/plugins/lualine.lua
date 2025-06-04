return {
	"nvim-lualine/lualine.nvim",
	opts = {
		options = {
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			globalstatus = true,
		},
		sections = {
			lualine_a = {
				{
					"mode",
					fmt = string.lower,
				},
			},
			lualine_c = {
				{
					"filename",
					path = 1,
				},
				{
					function()
						return require("dap").status()
					end,
					icon = { "", color = { fg = "#e7c664" } }, -- nerd icon.
					cond = function()
						if not package.loaded.dap then
							return false
						end
						local session = require("dap").session()
						return session ~= nil
					end,
				},
			},
			lualine_z = {
				{
					"location",
					icon = "",
				},
			},
		},
		extensions = {
			"nvim-tree",
		},
	},
}
