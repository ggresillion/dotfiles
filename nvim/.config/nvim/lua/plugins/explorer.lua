return {
    {
        'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>e", function() require("oil").open() end, desc = "Open File Tree" },
        },
    },
}
