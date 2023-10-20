return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'mfussenegger/nvim-jdtls',
    },
    lazy = true,
    init = function()
        vim.keymap.set('n', '<leader>db', '<cmd>lua require(\'dap\').toggle_breakpoint()<cr>')
        vim.keymap.set('n', '<leader>dc', '<cmd>lua require(\'dap\').continue()<cr>')
    end
}
