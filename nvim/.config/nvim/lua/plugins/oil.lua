return {
  'stevearc/oil.nvim',
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  lazy = false,
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    keymaps = {
      ["<C-h>"] = false,
      ["<C-l>"] = false,
    },
  },
  keys = {
    { "<leader>e", function() require("oil").open() end, desc = "Open File Tree" },
  },
}
