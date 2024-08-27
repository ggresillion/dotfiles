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
            -- golangci_lint_ls = {
            --     handlers = {
            --         ["textDocument/publishDiagnostics"] = convert_errors_to_warnings
            --     }
            -- },
        }
    },
    {
        "mfussenegger/nvim-dap",
        opts = {
            setup = function()
                local dap = require('dap')
                local function debug_go_file(file)
                    dap.run({
                        type = 'delve',
                        name = 'Debug Go File',
                        request = 'launch',
                        program = file,
                    })
                end
                vim.api.nvim_create_user_command('GoDebug', function(opts)
                    debug_go_file(opts.args)
                end, { nargs = 1, complete = 'file' })
            end,
            adapters = {
                delve = {
                    type = 'server',
                    port = '${port}',
                    executable = {
                        command = 'dlv',
                        args = { 'dap', '-l', '127.0.0.1:${port}' },
                    }
                },
                delve_remote = {
                    type = "server",
                    host = "127.0.0.1",
                    port = 38698,
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
}
