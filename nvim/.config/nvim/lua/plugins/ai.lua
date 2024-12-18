return {
    -- {
    --     "monkoose/neocodeium",
    --     event = "VeryLazy",
    --     opts = {
    --         silent = true,
    --     },
    --     keys = {
    --         { "<A-f>", function() require("neocodeium").accept() end,              mode = "i" },
    --         { "<A-w>", function() require("neocodeium").accept_word() end,         mode = "i" },
    --         { "<A-a>", function() require("neocodeium").accept_line() end,         mode = "i" },
    --         { "<A-e>", function() require("neocodeium").cycle_or_complete() end,   mode = "i" },
    --         { "<A-r>", function() require("neocodeium").cycle_or_complete(-1) end, mode = "i" },
    --         { "<A-c>", function() require("neocodeium").clear() end,               mode = "i" },
    --     },
    -- },
    -- {
    --     "olimorris/codecompanion.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --         "nvim-telescope/telescope.nvim", -- Optional
    --         {
    --             "stevearc/dressing.nvim",    -- Optional: Improves the default Neovim UI
    --             opts = {},
    --         },
    --     },
    --     opts = {
    --         adapters = {
    --             custom = function()
    --                 return require("codecompanion.adapters").extend("ollama", {
    --                     name = "custom",
    --                     schema = {
    --                         model = {
    --                             default = "mistral",
    --                         },
    --                         -- num_ctx = {
    --                         --     default = 16384,
    --                         -- },
    --                         -- num_predict = {
    --                         --     default = -1,
    --                         -- },
    --                     },
    --                 })
    --             end,
    --         },
    --         strategies = {
    --             chat = {
    --                 adapter = "custom",
    --             },
    --             inline = {
    --                 adapter = "custom",
    --             },
    --             agent = {
    --                 adapter = "custom",
    --             },
    --         },
    --     },
    -- }
    {
        "supermaven-inc/supermaven-nvim",
        opts = {
            disable_inline_completion = true,
            disable_keymaps = true,
        },
        dependencies = {
            {
                'saghen/blink.compat',
                lazy = true,
                opts = {},
            },
            {
                "saghen/blink.cmp",
                opts = {
                    sources = {
                        default = { "supermaven" },
                        providers = {
                            supermaven = {
                                name = 'supermaven',
                                module = 'blink.compat.source',
                                score_offset = 10,
                                opts = {},
                                transform_items = function(_, items)
                                    local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                                    local kind_idx = #CompletionItemKind + 1
                                    CompletionItemKind[kind_idx] = "Assistant"
                                    for _, item in ipairs(items) do
                                        item.kind = kind_idx
                                    end
                                    return items
                                end,
                            },
                        },
                    },
                },
            },
        },
    },
}
