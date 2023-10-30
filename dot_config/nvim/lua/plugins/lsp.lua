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
                    -- gopls = lsp_zero.noop,
                    jdtls = function()
                        require('lspconfig').jdtls.setup({
                            cmd = {
                                "jdtls",
                                "--jvm-arg=" ..
                                string.format("-javaagent:%s", vim.fn.expand "$MASON/share/jdtls/lombok.jar"),
                            },
                        })
                    end
                }
            })
        end
    },
    {
        'williamboman/mason.nvim',
        config = true
    },
}
