return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    init = function()
        -- disable netrw at the very start of your init.lua
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true
    end,
    keys = {
        { "<leader>e", function() require "nvim-tree.api".tree.toggle({find_file=true}) end, desc = "Open File Tree" }
    },
    opts = {
        actions = {
            open_file = {
                quit_on_open = true,
            },
        },
        renderer = {
            group_empty = true,
        },
    },
}
