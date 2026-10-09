vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
})

vim.lsp.enable({
	"lua_ls",
	"nixd",
	"gopls",
	"golangci_lint_ls",
	"ts_ls",
})
