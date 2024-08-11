return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        keys = {
            { "<leader>haa", function() require("harpoon"):list():add() end,          desc = "Harpoon: Append" },
            {
                "<leader>hh",
                function()
                    local conf = require("telescope.config").values
                    local function toggle_telescope(harpoon_files)
                        local file_paths = {}
                        for _, item in ipairs(harpoon_files.items) do
                            table.insert(file_paths, item.value)
                        end

                        require("telescope.pickers").new({}, {
                            prompt_title = "Harpoon",
                            finder = require("telescope.finders").new_table({
                                results = file_paths,
                            }),
                            previewer = conf.file_previewer({}),
                            sorter = conf.generic_sorter({}),
                        }):find()
                    end
                    toggle_telescope(require("harpoon"):list())
                end,
                desc = "Harpoon: Open"
            },

            { "<M-&>",       function() require("harpoon"):list():select(1) end,      desc = "Harpoon: Select 1" },
            { "<M-é>",       function() require("harpoon"):list():select(2) end,      desc = "Harpoon: Select 2" },
            { "<M-\">",      function() require("harpoon"):list():select(3) end,      desc = "Harpoon: Select 3" },
            { "<M-'>",       function() require("harpoon"):list():select(4) end,      desc = "Harpoon: Select 4" },
            { "<M-(>",       function() require("harpoon"):list():select(5) end,      desc = "Harpoon: Select 5" },
            { "<M-§>",       function() require("harpoon"):list():select(6) end,      desc = "Harpoon: Select 6" },
            { "<M-è>",       function() require("harpoon"):list():select(7) end,      desc = "Harpoon: Select 7" },
            { "<M-!>",       function() require("harpoon"):list():select(8) end,      desc = "Harpoon: Select 8" },
            { "<M-ç>",       function() require("harpoon"):list():select(9) end,      desc = "Harpoon: Select 9" },
            { "<M-à>",       function() require("harpoon"):list():select(10) end,     desc = "Harpoon: Select 10" },

            { "<leader>ha1", function() require("harpoon"):list():replace_at(1) end,  desc = "Harpoon: Replace 1" },
            { "<leader>ha2", function() require("harpoon"):list():replace_at(2) end,  desc = "Harpoon: Replace 2" },
            { "<leader>ha3", function() require("harpoon"):list():replace_at(3) end,  desc = "Harpoon: Replace 3" },
            { "<leader>ha4", function() require("harpoon"):list():replace_at(4) end,  desc = "Harpoon: Replace 4" },
            { "<leader>ha5", function() require("harpoon"):list():replace_at(5) end,  desc = "Harpoon: Replace 5" },
            { "<leader>ha6", function() require("harpoon"):list():replace_at(6) end,  desc = "Harpoon: Replace 6" },
            { "<leader>ha7", function() require("harpoon"):list():replace_at(7) end,  desc = "Harpoon: Replace 7" },
            { "<leader>ha8", function() require("harpoon"):list():replace_at(8) end,  desc = "Harpoon: Replace 8" },
            { "<leader>ha9", function() require("harpoon"):list():replace_at(9) end,  desc = "Harpoon: Replace 9" },
            { "<leader>ha0", function() require("harpoon"):list():replace_at(10) end, desc = "Harpoon: Replace 10" },

            { "<M-p>",       function() require("harpoon"):list():prev() end,         desc = "Harpoon: Previous" },
            { "<M-n>",       function() require("harpoon"):list():next() end,         desc = "Harpoon: Next" },
        }
    }
}
