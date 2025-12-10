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
vim.lsp.config("golangci-lint", {
	cmd = { "golangci-lint-langserver" },
	filetypes = { "go", "gomod" },
	init_options = {
		command = { "golangci-lint", "run", "--output.json.path=stdout", "--show-stats=false" },
	},
	root_markers = {
		".golangci.yml",
		".golangci.yaml",
		".golangci.toml",
		".golangci.json",
		"go.work",
		"go.mod",
		".git",
	},
	before_init = function(_, config)
		-- detect v1
		local v1, v2 = false, false
		if vim.fn.executable("go") == 1 then
			local exe = vim.fn.exepath("golangci-lint")
			local version = vim.system({ "go", "version", "-m", exe }):wait()
			v1 = string.match(version.stdout, "\tmod\tgithub.com/golangci/golangci%-lint\t")
			v2 = string.match(version.stdout, "\tmod\tgithub.com/golangci/golangci%-lint/v2\t")
		end
		if not v1 and not v2 then
			local version = vim.system({ "golangci-lint", "version" }):wait()
			v1 = string.match(version.stdout, "version v?1%.")
		end

		-- Compute merge base with origin/master
		local merge_base = nil
		if vim.fn.executable("git") == 1 then
			local result = vim.system({ "git", "merge-base", "origin/master", "HEAD" }):wait()
			if result.code == 0 then
				merge_base = vim.trim(result.stdout)
			end
		end

		-- Apply version-specific options + merge-base filter
		if v1 then
			config.init_options.command = {
				"golangci-lint",
				"run",
				"--out-format",
				"json",
			}
		else
			config.init_options.command = {
				"golangci-lint",
				"run",
				"--output.json.path=stdout",
				"--show-stats=false",
			}
		end

		-- Add --new-from-rev if detected
		if merge_base then
			table.insert(config.init_options.command, "--new-from-rev")
			table.insert(config.init_options.command, merge_base)
		end
	end,
})

vim.lsp.enable(mason_lsps)
vim.lsp.enable(external_lsps)
