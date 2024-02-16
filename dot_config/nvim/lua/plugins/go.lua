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
    -- {
    --     "leoluz/nvim-dap-go",
    --     opts = {},
    -- }
}
