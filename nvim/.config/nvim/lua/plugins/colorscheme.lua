return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    transparent_background = true,
  },
  init = function()
    -- load the colorscheme here
    vim.cmd([[colorscheme catppuccin]])
  end,
}
