return {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
        transparent_background = true,
        integrations = {
            mason = true,
            cmp = true,
            treesitter = true,
            telescope = {
                enabled = true,
            }
        },
    },
}
