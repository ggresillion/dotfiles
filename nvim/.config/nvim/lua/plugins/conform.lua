return {
	"stevearc/conform.nvim",
	event = "BufEnter",
	opts = {
		formatters_by_ft = {
			html = { "prettier" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			go = { "gofumpt", "goimports" },
			json = { "jq" },
			lua = { "stylua" },
			markdown = { "prettier" },
			sql = { "sqlfluff" },
			nix = { "nixfmt" },
			xml = { "xmllint" },
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 500,
		},
	},
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = { "n", "v" },
			desc = "Conform: [C]ode [F]ormat",
		},
	},
}
