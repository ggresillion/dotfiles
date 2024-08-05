return {
    {
        "olimorris/persisted.nvim",
        lazy = false,
        opts = {
            autoload = false,
        },
        config = function(_, opts)
            require("persisted").setup(opts)
            require("telescope").load_extension("persisted")
        end,
        keys = {
            { "<leader>fp", function() require('telescope').extensions.persisted.persisted() end, desc = "List persisted sessions" },
        },
    }
}
