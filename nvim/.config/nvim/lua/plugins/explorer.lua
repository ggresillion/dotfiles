return {
    {
        'stevearc/oil.nvim',
        lazy = false,
        opts = {
            keymaps = {
                ["<C-h>"] = false,
                ["<C-v>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
                ["<C-l>"] = false,
            },
        },
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>e", function() require("oil").open() end, desc = "Open File Tree" },
        },
    },
}
