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
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            -- This will not install any breaking changes.
            -- For major updates, this must be adjusted manually.
            version = "^1.0.0",
            config = function()
                require("telescope").load_extension("live_grep_args")
            end
        },
    },
    opts = {
        defaults = {
            file_ignore_patterns = {
                "vendor/",
                "node_modules/",
            },
            layout_strategy = 'vertical',
            layout_config = { height = 0.95 },
        },
    },
    keys = {
        { "<leader>ff", function() require("telescope.builtin").find_files() end,                       desc = "Find Files (root dir)" },
        { "<leader>fg", function() require('telescope').extensions.live_grep_args.live_grep_args() end, desc = "Grep (root dir)" },
        { "<leader>fb", function() require("telescope.builtin").buffers() end,                          desc = "Buffer" },
        { "<leader>fh", function() require("telescope.builtin").help_tags() end,                        desc = "Help Pages" },
        { "<leader>fd", function() require("telescope.builtin").diagnostics() end,                      desc = "Workspace diagnostics" },
        { "<leader>fs", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end,    desc = "Find symbols" },
    },
}
