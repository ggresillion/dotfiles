return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
  keys = {
    { "<leader>gdl", function() require('gitsigns').preview_hunk() end, desc = "Git Diff Line" },
    { "<leader>gdf", function() require('gitsigns').diffthis() end,     desc = "Git Diff File" },
    { "<leader>grh", function() require('gitsigns').reset_hunk() end,   desc = "Git Reset Hunk" },
  },
}
