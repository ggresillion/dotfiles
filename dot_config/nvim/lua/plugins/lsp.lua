return {
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            {

                "VonHeikemen/lsp-zero.nvim",
                "williamboman/mason-lspconfig.nvim",
                {
                    "williamboman/mason.nvim",
                    opts = {},
                },
            },
        },
        keys = {
            { "<leader>cl", "<cmd>LspInfo<cr>",                                                                     desc = "Lsp Info" },
            { "gd",         function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end,      desc = "Goto Definition", },
            { "gD",         vim.lsp.buf.declaration,                                                                desc = "Goto Declaration" },
            { "gr",         function() require("telescope.builtin").lsp_references() end,                           desc = "References" },
            { "gi",         function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end,  desc = "Goto Implementation" },
            { "go",         function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
            { "K",          function() vim.lsp.buf.hover() end,                                                     desc = "Hover" },
            { "gs",         vim.lsp.buf.signature_help,                                                             desc = "Signature Help", },
            { "<c-k>",      vim.lsp.buf.signature_help,                                                             desc = "Signature Help",        mode = "i", },
            { "<leader>ca", vim.lsp.buf.code_action,                                                                desc = "Code Action",           mode = { "n", "v" } },
            { "<leader>cf", function() vim.lsp.buf.format({ async = true }) end,                                    desc = "Format Buffer",         mode = { "n", "v" } },
            { "<leader>cr", vim.lsp.buf.rename,                                                                     desc = "Rename", },
            { "<leader>cd", vim.diagnostic.open_float,                                                              desc = "Line Diagnostic" },
        },
        config = function()
            -- workaround to prevent lsp-zero to set handlers and conflict with noice
            -- vim.g.lsp_zero_ui_float_border = 0
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_lspconfig()
            require("mason-lspconfig").setup({
                handlers = {
                    lsp_zero.default_setup,
                }
            })
        end
    },
}
