return {
    {
        "supermaven-inc/supermaven-nvim",
        opts = {
            disable_inline_completion = true,
            disable_keymaps = true,
        },
        dependencies = {
            {
                "saghen/blink.cmp",
                dependencies = {
                    "saghen/blink.compat",
                },
                opts = {
                    sources = {
                        default = { "supermaven" },
                        providers = {
                            supermaven = {
                                name = 'supermaven',
                                module = 'blink.compat.source',
                                score_offset = 100,
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
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            strategies = {
                chat = {
                    adapter = "openrouter",
                },
                inline = {
                    adapter = "openrouter",
                },
            },
            adapters = {
                ollama_deepseek = function()
                    return require("codecompanion.adapters").extend("ollama", {
                        name = "ollama_deepseek",
                        schema = {
                            model = {
                                default = "deepseek-coder:6.7b",
                            },
                        },
                    })
                end,
                openrouter = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        name = "openrouter",
                        env = {
                            api_key = "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",
                            url = "https://openrouter.ai/api",
                        },
                        schema = {
                            model = {
                                default = "deepseek/deepseek-chat:free"
                            }
                        }
                    })
                end,
            },
            opts = {
                log_level = "TRACE",
            }
        },
    },
}
