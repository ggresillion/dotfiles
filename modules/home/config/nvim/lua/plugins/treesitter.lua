vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- Bruno (.bru) is not shipped by nvim-treesitter, so the parser is registered
-- manually; the grammar repo also provides the highlight queries.
vim.filetype.add({ extension = { bru = "bruno" } })
vim.api.nvim_create_autocmd("User", {
	pattern = "TSUpdate",
	callback = function()
		require("nvim-treesitter.parsers").bruno = {
			install_info = {
				url = "https://github.com/Scalamando/tree-sitter-bruno",
				queries = "queries",
			},
		}
	end,
})

require("nvim-treesitter").setup({})
require("nvim-treesitter").install({ "vim", "lua", "nix", "go", "json", "javascript", "typescript", "http", "bruno" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		local started = pcall(vim.treesitter.start)
		if started then
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
