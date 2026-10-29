vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
})

-- tinted-nvim's base16/base24 schemes need its own lualine theme; "auto" would look for nvim-base16.
local function theme()
	local name = vim.g.colors_name or ""
	if name:match("^base16") or name:match("^base24") then
		return "tinted"
	end
	return "auto"
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local config = require("lualine").get_config()
		config.options.theme = theme()
		require("lualine").setup(config)
	end,
})

require("lualine").setup({
	options = {
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = true,
		theme = theme(),
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
		lualine_x = {
			{
				function()
					return require("netscript.statusline").buffer_ram()
				end,
				cond = function()
					return package.loaded.netscript ~= nil
				end,
			},
			{
				function()
					return require("netscript.statusline").ns_status()
				end,
				cond = function()
					return package.loaded.netscript ~= nil
				end,
			},
			"filetype",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})
