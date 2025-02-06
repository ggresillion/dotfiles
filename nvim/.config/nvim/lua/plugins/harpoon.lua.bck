return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            settings = {
                sync_on_ui_close = true,
            },
        },
        keys = {
            { "<leader>ha", function() require("harpoon"):list():add() end,                                    desc = "Harpoon: Append" },
            { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon: Open" },
            { "<M-&>",      function() require("harpoon"):list():select(1) end,                                desc = "Harpoon: Select 1" },
            { "<M-é>",      function() require("harpoon"):list():select(2) end,                                desc = "Harpoon: Select 2" },
            { "<M-\">",     function() require("harpoon"):list():select(3) end,                                desc = "Harpoon: Select 3" },
            { "<M-'>",      function() require("harpoon"):list():select(4) end,                                desc = "Harpoon: Select 4" },
            { "<M-(>",      function() require("harpoon"):list():select(5) end,                                desc = "Harpoon: Select 5" },
            { "<M-§>",      function() require("harpoon"):list():select(6) end,                                desc = "Harpoon: Select 6" },
            { "<M-è>",      function() require("harpoon"):list():select(7) end,                                desc = "Harpoon: Select 7" },
            { "<M-!>",      function() require("harpoon"):list():select(8) end,                                desc = "Harpoon: Select 8" },
            { "<M-ç>",      function() require("harpoon"):list():select(9) end,                                desc = "Harpoon: Select 9" },
            { "<M-à>",      function() require("harpoon"):list():select(10) end,                               desc = "Harpoon: Select 10" },
            { "<M-p>",      function() require("harpoon"):list():prev() end,                                   desc = "Harpoon: Previous" },
            { "<M-n>",      function() require("harpoon"):list():next() end,                                   desc = "Harpoon: Next" },
        }
    }
}
