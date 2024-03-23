return {
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
        },
        ft = { "go", "gomod" },
        build = ":lua require(\"go.install\").update_all_sync()", -- if you need to install/update all binaries
        config = function()
            require("go").setup({
                lsp_cfg = false,
                lsp_keymaps = false,
                dap_debug_keymap = false,
                icons = false,
            })
            -- auto format
            local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require("go.format").goimport()
                end,
                group = format_sync_grp,
            })
        end,
    },
    {
        "leoluz/nvim-dap-go",
        lazy = false,
        opts = {
            -- delve = {
            --     port = 40000,
            -- },
            dap_configurations = {
                {
                    type = "go",
                    name = "Attach remote",
                    mode = "remote",
                    request = "attach",
                    substitutePath = {
                        {
                            from = "${workspaceFolder}",
                            to = "/go/src/github.com/thetreep/thetreep-api",
                        },
                    },
                },
            },
        },
        keys = {
            { "<leader>dg", function() require("dap-go").debug_test() end, desc = "Debug test (Go)" },
        },
    }
}
