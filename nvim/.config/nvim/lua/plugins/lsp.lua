return {
    -- "neovim/nvim-lspconfig",
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            "williamboman/mason-lspconfig.nvim",
            dependencies = {
                {
                    "williamboman/mason.nvim",
                    opts = {},
                },
            },
            opts = {
                automatic_installation = true,
            },
        }
    },
    config = function(_, opts)
        for k, v in pairs(opts) do
            require("lspconfig")[k].setup(v)
        end
    end,
    keys = {
        { "<leader>cl", "<cmd>LspInfo<cr>",      desc = "Lsp Info" },
        {
            "gd",
            function()
                require("telescope.builtin").lsp_definitions({
                    reuse_win = true,
                    file_ignore_patterns = {},
                })
            end,
            desc = "Goto Definition",
        },
        { "gD",         vim.lsp.buf.declaration, desc = "Goto Declaration" },
        {
            "gr",
            function()
                require("telescope.builtin").lsp_references({
                    include_declaration = false,
                    file_ignore_patterns = {},
                })
            end,
            desc = "References"
        },
        {
            "gi",
            function()
                require("telescope.builtin").lsp_implementations({
                    reuse_win = true,
                    file_ignore_patterns = {},
                })
            end,
            desc = "Goto Implementation"
        },
        {
            "go",
            function()
                require("telescope.builtin").lsp_type_definitions({
                    reuse_win = true,
                    file_ignore_patterns = {},
                })
            end,
            desc = "Goto T[y]pe Definition"
        },
        { "K",          vim.lsp.buf.hover,                                   desc = "Hover" },
        { "gs",         vim.lsp.buf.signature_help,                          desc = "Signature Help", },
        { "<c-k>",      vim.lsp.buf.signature_help,                          desc = "Signature Help", mode = "i", },
        { "<leader>ca", vim.lsp.buf.code_action,                             desc = "Code Action",    mode = { "n", "v" } },
        { "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, desc = "Format Buffer",  mode = { "n", "v" } },
        { "<leader>cr", vim.lsp.buf.rename,                                  desc = "Rename", },
        { "<leader>cd", vim.diagnostic.open_float,                           desc = "Line Diagnostic" },
    },
}
