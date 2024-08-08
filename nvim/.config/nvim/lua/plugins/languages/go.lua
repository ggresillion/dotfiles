-- Function to convert all errors to warnings
local function convert_errors_to_warnings(_, result, ctx, config)
    if result.diagnostics then
        for _, diagnostic in ipairs(result.diagnostics) do
            if diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
                diagnostic.severity = vim.lsp.protocol.DiagnosticSeverity.Warning
            end
        end
    end
    -- Call the default handler
    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
end

return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            gopls = {},
            golangci_lint_ls = {
                handlers = {
                    ["textDocument/publishDiagnostics"] = convert_errors_to_warnings
                }
            },
        }
    },
    -- {
    --     "jay-babu/mason-nvim-dap.nvim",
    --     opts = {
    --         ensure_installed = { "delve" },
    --     },
    -- },
    {
        "mfussenegger/nvim-dap",
        opts = {
            adapters = {
                delve = {
                    type = "server",
                    host = "127.0.0.1",
                    port = 38697,
                },
            },
            configurations = {
                go = {
                    {
                        type = "delve",
                        name = "Debug",
                        request = "launch",
                        program = "${file}"
                    },
                    {
                        type = "delve",
                        name = "Debug test", -- configuration for debugging test files
                        request = "launch",
                        mode = "test",
                        program = "${file}"
                    },
                    -- works with go.mod packages and sub packages
                    {
                        type = "delve",
                        name = "Debug test (go.mod)",
                        request = "launch",
                        mode = "test",
                        program = "./${relativeFileDirname}"
                    }
                },
            },
        },
    },
    -- {
    --     "leoluz/nvim-dap-go",
    --     lazy = false,
    --     opts = {
    --         delve = {
    --             port = 40000,
    --         },
    --         dap_configurations = {
    --             {
    --                 type = "go",
    --                 name = "Attach remote",
    --                 mode = "remote",
    --                 request = "attach",
    --                 substitutePath = {
    --                     {
    --                         from = "${workspaceFolder}",
    --                         to = "/go/src/github.com/thetreep/thetreep-api",
    --                     },
    --                 },
    --             },
    --         },
    --     },
    --     keys = {
    --         { "<leader>dg", function() require("dap-go").debug_test() end, desc = "Debug test (Go)" },
    --     },
    -- },
}
