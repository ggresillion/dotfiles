return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    init = function()
        vim.cmd.colorscheme("catppuccin")
    end,
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
