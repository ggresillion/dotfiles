vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
	{ src = "https://github.com/monkoose/neocodeium" },
})

local neocodeium = require("neocodeium")

neocodeium.setup({
	silent = true,
	filter = function()
		return not require("blink.cmp").is_visible()
	end,
})

vim.keymap.set("i", "<A-w>", neocodeium.accept_word)
vim.keymap.set("i", "<A-a>", neocodeium.accept_line)
vim.keymap.set("i", "<A-e>", neocodeium.cycle_or_complete)
vim.keymap.set("i", "<A-r>", function()
	neocodeium.cycle_or_complete(-1)
end)
vim.keymap.set("i", "<A-c>", neocodeium.clear)

vim.api.nvim_create_autocmd("User", {
	pattern = "BlinkCmpMenuOpen",
	callback = neocodeium.clear,
})

require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
		["<Tab>"] = {
			function(cmp)
				if neocodeium.visible() then
					neocodeium.accept()
					return true
				end
				if cmp.snippet_active() then
					return cmp.accept()
				end
				return cmp.select_and_accept()
			end,
			"snippet_forward",
			"fallback",
		},
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = { auto_show = true },
		ghost_text = { enabled = true },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		providers = {
			snippets = { min_keyword_length = 2, score_offset = 10 },
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
