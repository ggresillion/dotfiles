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

        -- open nvim-tree
        vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")
    end,
    opts = {
        actions = {
            open_file = {
                quit_on_open = true,
            },
        },
    },
}

