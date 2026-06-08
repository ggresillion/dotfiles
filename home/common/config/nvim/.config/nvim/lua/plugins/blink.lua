vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
	{ src = "https://github.com/huijiro/blink-cmp-supermaven" },
	{ src = "https://github.com/Exafunction/windsurf.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
})

-- fix supermaven-nvim complaining about missing cmp
-- package.preload["cmp"] = function()
-- 	return {
-- 		register_source = function() end,
-- 		setup = function() end,
-- 	}
-- end

-- require("supermaven-nvim").setup({
-- 	disable_inline_completion = true,
-- 	disable_keymaps = true,
-- })

require("codeium").setup({})

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
		default = { "lsp", "path", "snippets", "buffer", "codeium" },
		providers = {
			snippets = { min_keyword_length = 2, score_offset = 10 },
			-- supermaven = { name = "supermaven", module = "blink-cmp-supermaven", async = true, score_offset = 4 },
			codeium = { name = "Codeium", module = "codeium.blink", async = true, score_offset = 4 },
			lsp = { score_offset = 3 },
			path = { min_keyword_length = 3, score_offset = 2 },
			buffer = { min_keyword_length = 3, score_offset = 1 },
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- native autocomplete -- not ready yet
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(ev)
-- 		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
-- 		if client:supports_method("textDocument/completion") then
-- 			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
-- 		end
-- 	end,
-- })
--
-- vim.o.autocomplete = true
-- vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }
--
-- vim.o.autotrigger = true
