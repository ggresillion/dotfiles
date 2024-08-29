return {
    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                go = { "gofumpt", "goimports" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                templ = { "templ" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        },
    },
}
