vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/f-person/auto-dark-mode.nvim" },
	{ src = "https://github.com/stevedylandev/ansi-nvim" },
})

    vim.cmd('colorscheme ansi')
    vim.opt.termguicolors = false

-- require("catppuccin").setup({
-- 	transparent_background = true,
-- 	flavour = "mocha",
-- })
-- vim.cmd("colorscheme catppuccin")
--
-- vim.cmd [[
--   highlight Normal       guifg=NONE guibg=NONE ctermfg=none ctermbg=none
--   highlight Comment      cterm=italic ctermfg=Green
--   highlight Identifier   ctermfg=Blue
--   highlight Function     ctermfg=Cyan
--   highlight String       ctermfg=Yellow
--   highlight Error        ctermfg=Red
--   highlight Warning      ctermfg=Magenta
-- ]]

-- require("auto-dark-mode").setup({
-- 	update_interval = 2000,
-- 	set_dark_mode = function()
-- 		vim.opt.background = "dark"
-- 		vim.cmd("colorscheme catppuccin-mocha")
-- 	end,
-- 	set_light_mode = function()
-- 		vim.opt.background = "light"
-- 		vim.cmd("colorscheme catppuccin-latte")
-- 	end,
-- 	fallback = "dark",
-- })
