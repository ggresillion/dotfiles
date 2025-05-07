return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      html = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      go = { "gofumpt", "goimports" },
      json = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      sql = { "sqlfluff" },
    },
      format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },
  },
}
