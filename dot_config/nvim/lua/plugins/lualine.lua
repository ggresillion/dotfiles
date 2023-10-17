return {
    'nvim-lualine/lualine.nvim',
    options = function()
--        local tokyonight = require('lualine.themes.tokyonight')
--        tokyonight.normal.c.bg = nil
        require('lualine').setup({
            options = {
                theme = 'tokyonight',
            }
        })
    end
}
