local languages = require("config.languages")

vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
})

local mason_lsps = {}
local external_lsps = {}

for _, lang in pairs(languages) do
	local lsp = lang.lsp
	if lsp then
		if type(lsp) == "string" then
			table.insert(mason_lsps, lsp)
		elseif type(lsp) == "table" then
			if lsp.external then
				table.insert(external_lsps, lsp.name)
			else
				table.insert(mason_lsps, lsp.name)
			end
		end
	end
end

require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = mason_lsps,
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

vim.lsp.enable(mason_lsps)
vim.lsp.enable(external_lsps)

vim.lsp.enable("golangci_lint_ls")
