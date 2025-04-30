return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            vacuum = {},
        },
        init = function()
            vim.filetype.add {
                pattern = {
                    ['api.*%.ya?ml'] = 'yaml.openapi',
                    ['api.*%.json'] = 'json.openapi',
                },
            }
        end,
    },
}
