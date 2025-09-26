vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
	{ src = "https://github.com/huijiro/blink-cmp-supermaven" },
})

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		print("Building blink.nvim...")
		local spec = ev.data.spec
		local kind = ev.data.kind
		local path = ev.data.path
		if kind == "install" or kind == "update" then
			local cmd = string.format("cd %s && cargo build --release", path)
			local result = vim.fn.system(cmd)
			if vim.v.shell_error == 0 then
				print("Built blink.nvim successfully")
			else
				print("Failed to build blink.nvim:\n" .. result)
			end
		end
	end,
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
