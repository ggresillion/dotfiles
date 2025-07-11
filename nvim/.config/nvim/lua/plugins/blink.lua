return {
	"saghen/blink.cmp",
	version = "1.*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	dependencies = {
		{
			"supermaven-inc/supermaven-nvim",
			init = function()
				package.preload["cmp"] = function()
					return {
						register_source = function() end, -- No-op for cmp registration
						setup = function() end, -- Additional mock if needed
					}
				end
			end,
			dependencies = {
				"huijiro/blink-cmp-supermaven",
			},
			opts = {
				disable_inline_completion = true,
				disable_keymaps = true,
			},
		},
	},
	opts = {
		keymap = {
			preset = "super-tab",
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			documentation = { auto_show = true },
			ghost_text = {
				enabled = true,
			},
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "supermaven" },
			providers = {
				snippets = {
					min_keyword_length = 2,
					score_offset = 10,
				},
				supermaven = {
					name = "supermaven",
					module = "blink-cmp-supermaven",
					async = true,
					score_offset = 4,
				},
				lsp = {
					score_offset = 3,
				},
				path = {
					min_keyword_length = 3,
					score_offset = 2,
				},
				buffer = {
					min_keyword_length = 3,
					score_offset = 1,
				},
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
