-- leader map
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- use system clipboard
vim.api.nvim_set_option("clipboard", "unnamed")

-- Indent
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "0"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 1
vim.opt.foldnestmax = 99

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Keymaps
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP: Rename Symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })
vim.keymap.set("i", "<C-Space>", "v:lua.vim.lsp.omnifunc", { expr = true, silent = true })
