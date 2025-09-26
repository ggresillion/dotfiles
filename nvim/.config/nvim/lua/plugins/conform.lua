vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

require("conform").setup({
	formatters_by_ft = {
		html = { "prettier" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		go = { "gofumpt", "goimports" },
		json = { "jq" },
		lua = { "stylua" },
		markdown = { "prettier" },
		sql = { "sqlfluff" },
		nix = { "nixfmt" },
		xml = { "xmllint" },
	},
	notify_on_error = false,
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		local disable_filetypes = { c = false, cpp = false }
		return {
			timeout_ms = 500,
			lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
		}
	end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, { desc = "Disable autoformat-on-save", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, { desc = "Re-enable autoformat-on-save" })

local map = vim.keymap.set
map({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Conform: [C]ode [F]ormat" })

map("n", "<leader>tf", function()
	if vim.b.disable_autoformat then
		vim.cmd("FormatEnable")
		vim.notify("Enabled autoformat for current buffer")
	else
		vim.cmd("FormatDisable!")
		vim.notify("Disabled autoformat for current buffer")
	end
end, { desc = "Toggle autoformat for current buffer" })

map("n", "<leader>tF", function()
	if vim.g.disable_autoformat then
		vim.cmd("FormatEnable")
		vim.notify("Enabled autoformat globally")
	else
		vim.cmd("FormatDisable")
		vim.notify("Disabled autoformat globally")
	end
end, { desc = "Toggle autoformat globally" })
