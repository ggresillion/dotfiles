return {
    "folke/trouble.nvim",
    keys = {
        { "<leader>xx", function() require("trouble").toggle("diagnostics_by_severity") end, desc = "Diagnostics" },
    },
    opts = {
        modes = {
            diagnostics_by_severity = {
                mode = "diagnostics",
                filter = function(items)
                    local severity = vim.diagnostic.severity.HINT
                    for _, item in ipairs(items) do
                        severity = math.min(severity, item.severity)
                    end
                    return vim.tbl_filter(function(item)
                        return item.severity == severity
                    end, items)
                end,
                preview = {
                    type = "split",
                    relative = "win",
                    position = "right",
                    size = 0.5,
                },
            },
        },
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        init = function()
            local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
            vim.diagnostic.config({
                virtual_text = false,
            });
        end,
        opts = {},
    }
}
