return {
    'ray-x/navigator.lua',
    opts = {
        keymaps = {
            { key = 'F3', func = vim.lsp.buf.format,           mode = 'n', desc = 'format' },
            { key = 'F3', func = vim.lsp.buf.range_formatting, mode = 'v', desc = 'range format' },
        },
    },
}
