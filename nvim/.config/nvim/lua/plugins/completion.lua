return {
    {
        "saghen/blink.cmp",
        lazy = false,
        build = "cargo build --release",
        dependencies = {
            "rafamadriz/friendly-snippets"
        },
        opts = {
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            keymap = { preset = "super-tab" },
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
                ghost_text = {
                    enabled = true,
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                kind_icons = {
                    Assistant = "",
                },
            },
        },
        opts_extend = { "sources.default", "providers" },
    },
}
