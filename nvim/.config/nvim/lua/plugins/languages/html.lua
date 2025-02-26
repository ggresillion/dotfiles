return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            html = {},
            eslint = {},
        },
    },
    {
        "luckasRanarison/tailwind-tools.nvim",
        name = "tailwind-tools",
        build = ":UpdateRemotePlugins",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            -- "nvim-telescope/telescope.nvim", -- optional
            "neovim/nvim-lspconfig", -- optional
        },
        opts = {}                    -- your configuration
    }
}
