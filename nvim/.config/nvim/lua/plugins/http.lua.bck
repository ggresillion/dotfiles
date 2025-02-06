return {
    {
        "mistweaverco/kulala.nvim",
        opts = {},
        keys = {
            {
                "<leader>hx",
                function()
                    local kulala = require("kulala")
                    kulala.run()
                end,
                desc = "Execute HTTP request"
            },
            {
                "<leader>hi",
                function()
                    local kulala = require("kulala")
                    kulala.inspect()
                end,
                desc = "Inspect HTTP request"
            },
            {
                "<leader>he",
                function()
                    local kulala = require("kulala")
                    kulala.set_selected_env()
                end,
                desc = "Change HTTP environment"
            },
            {
                "<leader>hcc",
                function()
                    local kulala = require("kulala")
                    kulala.copy()
                end,
                desc = "Copy HTTP request as curl"
            },
            {
                "<leader>hci",
                function()
                    local kulala = require("kulala")
                    kulala.from_curl()
                end,
                desc = "Insert HTTP request from curl"
            },
        },
    }
}
