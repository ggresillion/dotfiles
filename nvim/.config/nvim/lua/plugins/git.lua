return {
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
        },
        keys = {
            { "<leader>gp",  function() require("gitsigns").prev_hunk() end,                                       desc = "Previous Hunk" },
            { "<leader>gn",  function() require("gitsigns").next_hunk() end,                                       desc = "Next Hunk" },
            { "<leader>gs",  function() require("gitsigns").stage_hunk { vim.fn.line("."), vim.fn.line("n") } end, desc = "Stage Hunk" },
            { "<leader>gr",  function() require("gitsigns").reset_hunk { vim.fn.line("."), vim.fn.line("n") } end, desc = "Reset Hunk" },
            { "<leader>gS",  function() require("gitsigns").stage_buffer() end,                                    desc = "Stage Buffer" },
            { "<leader>gu",  function() require("gitsigns").undo_stage_buffer() end,                               desc = "Undo Stage Buffer" },
            { "<leader>gR",  function() require("gitsigns").reset_buffer() end,                                    desc = "Reset Buffer" },
            { "<leader>gP",  function() require("gitsigns").preview_hunk() end,                                    desc = "Preview Hunk" },
            { "<leader>gb",  function() require("gitsigns").blame_line({ full = true }) end,                       desc = "Blame Line" },
            { "<leader>gtb", function() require("gitsigns").toggle_current_line_blame() end,                       desc = "Toggle Blame" },
            { "<leader>gd",  function() require("gitsigns").diffthis() end,                                        desc = "Diff This" },
            { "<leader>gD",  function() require("gitsigns").diffthis("~") end,                                     desc = "Diff This ~" },
            { "<leader>gtd", function() require("gitsigns").toggle_deleted() end,                                  desc = "Toggle Deleted" },
        },
    },
    {
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "sindrets/diffview.nvim",
        opts = {},
    },
    {
        "tpope/vim-fugitive",
        cmd = {
            "Git",
            "G",
        },
    }
}
