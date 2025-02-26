return {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            "williamboman/mason-lspconfig.nvim",
            dependencies = {
                {
                    "williamboman/mason.nvim",
                    opts = {},
                },
            },
            opts = {
                automatic_installation = true,
            },
        }
    },
    config = function(_, opts)
        local lspconfig = require('lspconfig')
        for server, config in pairs(opts) do
            lspconfig[server].setup(config)
        end
    end,
    opts = {},
    keys = {
        { "K",          vim.lsp.buf.hover,                                   desc = "Hover" },
        { "gs",         vim.lsp.buf.signature_help,                          desc = "Signature Help", },
        { "<c-k>",      vim.lsp.buf.signature_help,                          desc = "Signature Help", mode = "i", },
        { "<leader>ca", vim.lsp.buf.code_action,                             desc = "Code Action",    mode = { "n", "v" } },
        { "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, desc = "Format Buffer",  mode = { "n", "v" } },
        { "<leader>cr", vim.lsp.buf.rename,                                  desc = "Rename", },
        { "<leader>cd", vim.diagnostic.open_float,                           desc = "Line Diagnostic" },
    },
}
