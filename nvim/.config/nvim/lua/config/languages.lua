return {
	lua = {
		lsp = "lua_ls",
		formatter = { "stylua" },
		parser = "lua",
	},
	go = {
		lsp = "gopls",
		formatter = { "gofumpt", "goimports" },
		parser = "go",
	},
	javascript = {
		lsp = "ts_ls",
		formatter = { "prettier" },
		parser = "javascript",
	},
	typescript = {
		lsp = "ts_ls",
		formatter = { "prettier" },
		parser = "typescript",
	},
	json = {
		lsp = "jsonls",
		formatter = { "jq" },
		parser = "json",
	},
	rust = {
		lsp = "rust_analyzer",
		formatter = {},
		parser = "rust",
	},
	terraform = {
		lsp = "terraformls",
		formatter = {},
		parser = "hcl",
	},
	python = {
		lsp = "pylsp",
		formatter = {},
		parser = "python",
	},
	html = {
		formatter = { "prettier" },
		parser = "html",
	},
	css = {
		formatter = { "prettier" },
		parser = "css",
	},
	markdown = {
		formatter = { "prettier" },
		parser = "markdown",
	},
	nushell = {
		lsp = {
			name = "nushell",
			external = true,
		},
	},
	kulala = {
		lsp = {
			name = "kulala",
			external = true,
		},
		-- parser = "kulala_http",
	},
	templ = {
		lsp = "templ",
		parser = "templ",
		formatter = { "templfmt" },
	},
	yaml = {
		lsp = "yamlls",
		parser = "yaml",
		formatter = { "prettier" },
	},
}
