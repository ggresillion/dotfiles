local languages = require("config.languages")

vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

local parsers = {}
for _, lang in pairs(languages) do
	if lang.parser then
		table.insert(parsers, lang.parser)
	end
end

require("nvim-treesitter").setup({})
require("nvim-treesitter").install(parsers)
require("nvim-treesitter").install("vim")

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
