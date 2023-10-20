return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
        init = function()
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            {
                'williamboman/mason-lspconfig.nvim',
            },
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()
            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({
                    buffer = bufnr,
                    preserve_mappings = false,
                    exclude = {
                        'gr',
                    },
                })
            end)
            require('mason-lspconfig').setup({
                handlers = {
                    lsp_zero.default_setup,
                    gopls = lsp_zero.noop,
                }
            })
        end
    },
    {
        'williamboman/mason.nvim',
        config = true
    },
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        config = function()
            local cmp = require('cmp')
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()
            local cmp_action = require('lsp-zero').cmp_action()
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<Tab>'] = cmp_action.tab_complete(),
                    ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
                })
            })
        end,
    },
}
