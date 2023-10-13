return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = 'LspInfo',
        event = {'BufReadPre', 'BufNewFile'},
        dependencies = {
            {'hrsh7th/cmp-nvim-lsp'},
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()
            lsp_zero.default_keymaps({buffer = bufnr})
        end
    },
    -- LSP install
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup({})
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            local lsp_zero = require('lsp-zero')
            require('mason-lspconfig').setup({
                handlers = {
                    lsp_zero.default_setup,
                }
            })
        end
    },
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {'L3MON4D3/LuaSnip'},
        },
        config = function()
            local cmp = require('cmp')
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

