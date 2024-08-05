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
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.golangci_lint_ls.setup {
                handlers = {
                    ["textDocument/publishDiagnostics"] = convert_errors_to_warnings
                }
            }
        end,
    }
}
