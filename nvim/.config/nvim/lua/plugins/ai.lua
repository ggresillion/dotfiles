return {
    {
        "supermaven-inc/supermaven-nvim",
        opts = {},
    },
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
        opts = {
            provider = "openrouter_deepseek",
            vendors = {
                openrouter_deepseek = {
                    __inherited_from = 'openai',
                    endpoint = 'https://openrouter.ai/api/v1',
                    api_key_name = 'OPENROUTER_API_KEY',
                    model = 'deepseek/deepseek-chat-v3-0324:free',
                    disable_tools = true
                },
            },
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "folke/snacks.nvim",
            "saghen/blink.compat",
            "nvim-tree/nvim-web-devicons",
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    }
}
