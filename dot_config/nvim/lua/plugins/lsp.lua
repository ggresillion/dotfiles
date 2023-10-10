return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {'L3MON4D3/LuaSnip'},
        },
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = 'LspInfo',
        event = {'BufReadPre', 'BufNewFile'},
        dependencies = {
            {'hrsh7th/cmp-nvim-lsp'},
            {
                'williamboman/mason-lspconfig.nvim',
                config = function()
                    require('mason-lspconfig').setup({
                        handlers = {
                            require('lsp-zero').default_setup,
                        }
                    })
                end
            },
            {
                'williamboman/mason.nvim',
                config = function()
                    require('mason').setup({})
                end
            },
        },
    },
}
