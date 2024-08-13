return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "dap-float",
                callback = function()
                    vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
                end
            })
        end,
        opts = {
            automatic_installation = true,
        },
        dependencies = {
            {
                "williamboman/mason.nvim",
                opts = {},
            },
            {
                "mfussenegger/nvim-dap",
                config = function(_, opts)
                    local dap = require("dap")
                    for k, v in pairs(opts.adapters) do
                        dap.adapters[k] = v
                    end
                    for k, v in pairs(opts.configurations) do
                        dap.configurations[k] = v
                    end
                end,
            },
            -- virtual text for the debugger
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
            },
            -- which key integration
            {
                "folke/which-key.nvim",
                optional = true,
                opts = {
                    defaults = {
                        ["<leader>d"] = { name = "+debug" },
                    },
                },
            },
        },
        keys = {
            {
                "<leader>dB",
                function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
                desc = "Breakpoint Condition"
            },
            {
                "<leader>db",
                function() require("dap").toggle_breakpoint() end,
                desc = "Toggle Breakpoint",
            },
            {
                "<leader>dl",
                function() require("dap").run_last() end,
                desc = "Run Last",
            },
            {
                "<leader>dc",
                function() require("dap").continue() end,
                desc = "Continue",
            },
            {
                "<leader>dC",
                function() require("dap").run_to_cursor() end,
                desc = "Run to Cursor",
            },
            {
                "<leader>dg",
                function() require("dap").goto_() end,
                desc = "Go to line (no execute)",
            },
            {
                "<leader>di",
                function() require("dap").step_into() end,
                desc = "Step Into",
            },
            {
                "<leader>dO",
                function() require("dap").step_out() end,
                desc = "Step Out",
            },
            {
                "<leader>do",
                function() require("dap").step_over() end,
                desc = "Step Over",
            },
            {
                "<leader>du",
                function() require("dap").up() end,
                desc = "Go up in the stack",
            },
            {
                "<leader>dd",
                function() require("dap").down() end,
                desc = "Go down in the stack",
            },
            {
                "<leader>dv",
                function() require("dap").repl.toggle() end,
                desc = "Toggle REPL",
            },
            {
                "<leader>dv",
                function() require('dap.ui.widgets').hover() end,
                desc = "Display the value of the variable under the cursor",
            },
            {
                "<leader>dt",
                function() require("dap").terminate() end,
                desc = "Terminate",
            },
            {
                "<leader>dx",
                function() require("dap").clear_breakpoints() end,
                desc = "Clear all breakpoints",
            },
        },
    },
}
