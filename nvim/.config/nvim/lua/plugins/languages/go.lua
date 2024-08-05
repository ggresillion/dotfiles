return {
    {
        "leoluz/nvim-dap-go",
        lazy = false,
        opts = {
            delve = {
                port = 40000,
            },
            dap_configurations = {
                {
                    type = "go",
                    name = "Attach remote",
                    mode = "remote",
                    request = "attach",
                    substitutePath = {
                        {
                            from = "${workspaceFolder}",
                            to = "/go/src/github.com/thetreep/thetreep-api",
                        },
                    },
                },
            },
        },
        keys = {
            { "<leader>dg", function() require("dap-go").debug_test() end, desc = "Debug test (Go)" },
        },
    }
}
