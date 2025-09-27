vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
	{ src = "https://github.com/huijiro/blink-cmp-supermaven" },
})

package.preload["cmp"] = function()
	return {
		register_source = function() end,
		setup = function() end,
	}
end

require("supermaven-nvim").setup({
	disable_inline_completion = true,
	disable_keymaps = true,
})

require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = { auto_show = true },
		ghost_text = { enabled = true },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer", "supermaven" },
		providers = {
			snippets = { min_keyword_length = 2, score_offset = 10 },
			supermaven = { name = "supermaven", module = "blink-cmp-supermaven", async = true, score_offset = 4 },
			lsp = { score_offset = 3 },
			path = { min_keyword_length = 3, score_offset = 2 },
			buffer = { min_keyword_length = 3, score_offset = 1 },
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
