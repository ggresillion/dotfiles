return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        keys = {
            { "<leader>ha",  function() require("harpoon"):list():append() end,  desc = "Harpoon: Append" },
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

            { "<leader>h&",  function() require("harpoon"):list():select(2) end, desc = "Harpoon: Select 1" },
            { "<leader>hé",  function() require("harpoon"):list():select(2) end, desc = "Harpoon: Select 2" },
            { "<leader>h\"", function() require("harpoon"):list():select(3) end, desc = "Harpoon: Select 3" },
            { "<leader>h'",  function() require("harpoon"):list():select(4) end, desc = "Harpoon: Select 4" },

            { "<leader>hk",  function() require("harpoon"):list():prev() end,    desc = "Harpoon: Previous" },
            { "<leader>hj",  function() require("harpoon"):list():next() end,    desc = "Harpoon: Next" },
        }
    }
}
