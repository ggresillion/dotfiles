-- LazyVim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Imports
require("settings")
require("remap")
require("utils")
require("lazy").setup({
    { import = "plugins" },
    { import = "plugins.languages" },
})

-- Functions
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath('config') .. '/lua/functions', [[v:val =~ '\.lua$']])) do
    local func_data = require('functions.' .. file:gsub('%.lua$', ''))
    if type(func_data) == 'table' and #func_data == 2 and
        type(func_data[1]) == 'string' and type(func_data[2]) == 'function' then
        vim.api.nvim_create_user_command(func_data[1], func_data[2], {})
    end
end
