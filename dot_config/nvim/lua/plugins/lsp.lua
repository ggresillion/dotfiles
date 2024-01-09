return {
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            {
                {
                    "williamboman/mason-lspconfig.nvim",
                    opts = {
                        ensure_installed = {},
                    },
                },
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
            { "K",          vim.lsp.buf.hover,                                                                      desc = "Hover" },
            { "gs",         vim.lsp.buf.signature_help,                                                             desc = "Signature Help", },
            { "<c-k>",      vim.lsp.buf.signature_help,                                                             desc = "Signature Help",        mode = "i", },
            { "<leader>ca", vim.lsp.buf.code_action,                                                                desc = "Code Action",           mode = { "n", "v" } },
            { "<leader>cf", function() vim.lsp.buf.format({ async = true }) end,                                    desc = "Format Buffer",         mode = { "n", "v" } },
            { "<leader>cr", vim.lsp.buf.rename,                                                                     desc = "Rename", },
            { "<leader>cd", vim.diagnostic.open_float,                                                              desc = "Line Diagnostic" },
        },
        config = function()
            require("mason-lspconfig").setup_handlers {
                function(server_name)
                    require("lspconfig")[server_name].setup {}
                end,
            }
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        version = false,
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
        init = function()
            vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
        end,
        opts = function()
            local cmp = require("cmp")
            return {
                mapping = {
                    ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<S-CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
                },
                experimental = {
                    ghost_text = {
                        hl_group = "CmpGhostText",
                    },
                },
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
            }
        end
    },
}
