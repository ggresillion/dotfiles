return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#0e1514',
				base01 = '#0e1514',
				base02 = '#808a89',
				base03 = '#808a89',
				base04 = '#d2dfdd',
				base05 = '#f8fffe',
				base06 = '#f8fffe',
				base07 = '#f8fffe',
				base08 = '#ffc09f',
				base09 = '#ffc09f',
				base0A = '#9beae0',
				base0B = '#a5ffab',
				base0C = '#d1fff9',
				base0D = '#9beae0',
				base0E = '#b8fff5',
				base0F = '#b8fff5',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#808a89',
				fg = '#f8fffe',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#9beae0',
				fg = '#0e1514',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#808a89' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#d1fff9', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#b8fff5',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#9beae0',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#9beae0',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#d1fff9',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a5ffab',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#d2dfdd' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#d2dfdd' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#808a89',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
