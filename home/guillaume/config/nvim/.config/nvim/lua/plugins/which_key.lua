vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
})

local wk = require("which-key")
wk.setup({})

vim.keymap.set("n", "<leader>?", function()
	wk.show({ global = false })
end, { silent = true })
