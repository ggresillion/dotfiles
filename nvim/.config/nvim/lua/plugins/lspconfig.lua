vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
})

local lsps = {
	"gopls",
	"lua_ls",
	"ts_ls",
	"tailwindcss",
	"jsonls",
	"golangci_lint_ls",
	"nil_ls",
	"terraformls",
	"pylsp",
	"rust_analyzer",
	"copilot",
}

require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = lsps,
	automatic_installation = true,
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

vim.lsp.enable(lsps)
vim.lsp.enable("nushell")
