return {
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        opts = {
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            keymap = {
                preset = "super-tab",
                ["<Tab>"] = { "accept", "fallback" },
            },
            completion = {
                menu = {
                    border = "rounded",
                },
                documentation = {
                    auto_show = true,
                    window = {
                        border = "rounded",
                    },

                },
                trigger = {
                    show_in_snippet = false,
                },
                list = {
                    selection = {
                        preselect = false,
                    },
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                },
            },
            appearance = {
                -- use_nvim_cmp_as_default = true,
                kind_icons = {
                    Assistant = "",
                },
            },
        },
        opts_extend = { "sources.default" },
    },
}
