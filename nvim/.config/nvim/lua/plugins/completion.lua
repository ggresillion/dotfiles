-- return {
--     "hrsh7th/nvim-cmp",
--     event = "InsertEnter",
--     dependencies = {
--         "hrsh7th/cmp-nvim-lsp",
--         "hrsh7th/cmp-buffer",
--         "hrsh7th/cmp-path",
--     },
--     opts = function()
--         vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
--         local cmp = require("cmp")
--         local defaults = require("cmp.config.default")()
--         local icons = {
--             Array         = " ",
--             Boolean       = "󰨙 ",
--             Class         = " ",
--             Codeium       = "󰘦 ",
--             Color         = " ",
--             Control       = " ",
--             Collapsed     = " ",
--             Constant      = "󰏿 ",
--             Constructor   = " ",
--             Copilot       = " ",
--             Enum          = " ",
--             EnumMember    = " ",
--             Event         = " ",
--             Field         = " ",
--             File          = " ",
--             Folder        = " ",
--             Function      = "󰊕 ",
--             Interface     = " ",
--             Key           = " ",
--             Keyword       = " ",
--             Method        = "󰊕 ",
--             Module        = " ",
--             Namespace     = "󰦮 ",
--             Null          = " ",
--             Number        = "󰎠 ",
--             Object        = " ",
--             Operator      = " ",
--             Package       = " ",
--             Property      = " ",
--             Reference     = " ",
--             Snippet       = " ",
--             String        = " ",
--             Struct        = "󰆼 ",
--             TabNine       = "󰏚 ",
--             Text          = " ",
--             TypeParameter = " ",
--             Unit          = " ",
--             Value         = " ",
--             Variable      = "󰀫 ",
--             Supermaven    = "",
--         }
--
--         -- local neocodeium = require("neocodeium")
--         -- local commands = require("neocodeium.commands")
--         --
--         -- cmp.event:on("menu_opened", function()
--         --     commands.disable()
--         --     neocodeium.clear()
--         -- end)
--         --
--         -- cmp.event:on("menu_closed", function()
--         --     commands.enable()
--         -- end)
--
--         return {
--             completion = {
--                 -- autocomplete = false,
--                 completeopt = "menu,menuone,noinsert",
--             },
--             mapping = cmp.mapping.preset.insert({
--                 ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
--                 ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
--                 ["<C-b>"] = cmp.mapping.scroll_docs(-4),
--                 ["<C-f>"] = cmp.mapping.scroll_docs(4),
--                 ["<C-Space>"] = cmp.mapping.complete(),
--                 ["<C-e>"] = cmp.mapping.abort(),
--                 ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--                 ["<S-CR>"] = cmp.mapping.confirm({
--                     behavior = cmp.ConfirmBehavior.Insert,
--                     select = true,
--                 }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--                 ["<C-CR>"] = function(fallback)
--                     cmp.abort()
--                     fallback()
--                 end,
--             }),
--             sources = cmp.config.sources({
--                 { name = "nvim_lsp" },
--                 { name = "path" },
--                 { name = "supermaven", priority = 10 },
--             }, {
--                 { name = "buffer" },
--             }),
--             formatting = {
--                 format = function(_, item)
--                     if icons[item.kind] then
--                         item.kind = icons[item.kind] .. item.kind
--                     end
--                     return item
--                 end,
--             },
--             experimental = {
--                 ghost_text = {
--                     hl_group = "CmpGhostText",
--                 },
--             },
--             sorting = defaults.sorting,
--             window = {
--                 completion = cmp.config.window.bordered(),
--                 documentation = cmp.config.window.bordered()
--             },
--         }
--     end,
--     config = function(_, opts)
--         for _, source in ipairs(opts.sources) do
--             source.group_index = source.group_index or 1
--         end
--         require("cmp").setup(opts)
--     end,
-- }

return {
    {
        "saghen/blink.cmp",
        lazy = false,
        build = "cargo build --release",
        opts = {
            sources = {
                default = { "lsp", "path", "luasnip", "buffer" },
            },
            keymap = { preset = "super-tab" },
            completion = {
                menu = {
                    border = "rounded",
                },
                documentation = {
                    auto_show = true,
                    window = {
                        border = "rounded",
                    },

                },
                ghost_text = {
                    enabled = true,
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                kind_icons = {
                    Assistant = "",
                },
            },
        },
        opts_extend = { "sources.default", "providers" },
    },
}
