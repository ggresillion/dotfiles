-- leader map
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- lsp
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP: Rename Symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })
vim.keymap.set("i", "<C-Space>", "v:lua.vim.lsp.omnifunc", { expr = true, silent = true })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostics" })

-- center screen
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- yank
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- indent
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- dead-key remaps for US International layout
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
map("n", "á", "'a", opts)
map("n", "Á", "'A", opts)
map("n", "é", "'e", opts)
map("n", "É", "'E", opts)
map("n", "í", "'i", opts)
map("n", "Í", "'I", opts)
map("n", "ó", "'o", opts)
map("n", "Ó", "'O", opts)
map("n", "ú", "'u", opts)
map("n", "Ú", "'U", opts)
map("n", "ý", "'y", opts)
map("n", "Ý", "'Y", opts)
map("n", "à", "`a", opts)
map("n", "À", "`A", opts)
map("n", "è", "`e", opts)
map("n", "È", "`E", opts)
map("n", "ì", "`i", opts)
map("n", "Ì", "`I", opts)
map("n", "ò", "`o", opts)
map("n", "Ò", "`O", opts)
map("n", "ù", "`u", opts)
map("n", "Ù", "`U", opts)
map("n", "ã", "~a", opts)
map("n", "Ã", "~A", opts)
map("n", "õ", "~o", opts)
map("n", "Õ", "~O", opts)
map("n", "ñ", "~n", opts)
map("n", "Ñ", "~N", opts)
map("n", "â", "^a", opts)
map("n", "Â", "^A", opts)
map("n", "ê", "^e", opts)
map("n", "Ê", "^E", opts)
map("n", "î", "^i", opts)
map("n", "Î", "^I", opts)
map("n", "ô", "^o", opts)
map("n", "Ô", "^O", opts)
map("n", "û", "^u", opts)
map("n", "Û", "^U", opts)
map("n", "ç", "'c", opts)
map("n", "Ç", "'C", opts)
map("n", "ä", '"a', opts)
map("n", "Ä", '"A', opts)
map("n", "ë", '"e', opts)
map("n", "Ë", '"E', opts)
map("n", "ï", '"i', opts)
map("n", "Ï", '"I', opts)
map("n", "ö", '"o', opts)
map("n", "Ö", '"O', opts)
map("n", "ü", '"u', opts)
map("n", "Ü", '"U', opts)
map("n", "ÿ", '"y', opts)
map("n", "Ÿ", '"Y', opts)
