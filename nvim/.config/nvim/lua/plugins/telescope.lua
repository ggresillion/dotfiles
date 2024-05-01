return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "folke/which-key.nvim",
            optional = true,
            opts = {
                defaults = {
                    ["<leader>f"] = { name = "+find" },
                },
            },
        },
    },
    keys = {
        { "<leader>ff", function() require("telescope.builtin").find_files() end,  desc = "Find Files (root dir)" },
        { "<leader>fg", function() require("telescope.builtin").live_grep() end,   desc = "Grep (root dir)" },
        { "<leader>fb", function() require("telescope.builtin").buffers() end,     desc = "Buffer" },
        { "<leader>fh", function() require("telescope.builtin").help_tags() end,   desc = "Help Pages" },
        { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Workspace diagnostics" },
    },
}
