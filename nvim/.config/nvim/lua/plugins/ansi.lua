return {
    {
        "m00qek/baleia.nvim",
        opts = {},
        config = function(_, opts)
            vim.g.baleia = require("baleia").setup(opts)

            -- run baleia on all REPL buffers
            vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
                pattern = "*dap-repl*",
                callback = function()
                    vim.g.baleia.automatically(vim.api.nvim_get_current_buf())
                end,
            })
        end
    },
}
