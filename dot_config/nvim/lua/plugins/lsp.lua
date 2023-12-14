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
        init = function()
            vim.g.lsp_zero_ui_float_border = 0
        end,
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_lspconfig()
            require("mason-lspconfig").setup({
                handlers = {
                    lsp_zero.default_setup,
                }
            })
        end
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
        },
        opts = function()
            local cmp = require("cmp")
            local cmp_action = require("lsp-zero").cmp_action()
            return {
                mapping = {
                    ["<Up>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
                    ["<Down>"] = cmp.mapping.select_next_item({ behavior = "select" }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-f>"] = cmp_action.luasnip_jump_forward(),
                    ["<C-b>"] = cmp_action.luasnip_jump_backward(),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<Tab>"] = cmp_action.luasnip_supertab(),
                    ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "luasnip" },
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
                }
            }
        end
    },
}
