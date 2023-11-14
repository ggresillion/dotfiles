-- Global
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>dd", "<cmd>lua vim.diagnostic.open_float()<CR>",
    { desc = "Show diagnostic popup", noremap = true, silent = true })
vim.keymap.set("n", "<leader>dj", "<cmd>lua vim.diagnostic.goto_next()<CR>",
    { desc = "Next diagnostic", noremap = true, silent = true })
vim.keymap.set("n", "<leader>dk", "<cmd>lua vim.diagnostic.goto_prev()<CR>",
    { desc = "Previous diagnostic", noremap = true, silent = true })
