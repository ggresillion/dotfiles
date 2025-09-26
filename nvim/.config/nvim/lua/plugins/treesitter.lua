vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

require("nvim-treesitter.configs").setup({
	auto_install = true,
	sync_install = false,
	highlight = { enable = true },
	indent = { enable = true },
})

-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "PackUpdated",
-- 	callback = function()
-- 		vim.cmd("TSUpdate")
-- 	end,
-- })
