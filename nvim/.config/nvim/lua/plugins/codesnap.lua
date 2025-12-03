vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name ~= "codesnap.nvim" then
			return
		end
		if kind ~= "install" and kind ~= "update" then
			return
		end
		vim.notify("codesnap.nvim: building...")
		vim.system({ "make" }, { cwd = ev.data.path })
		vim.notify("codesnap.nvim: done")
	end,
})

vim.pack.add({
	{ src = "https://github.com/mistricky/codesnap.nvim" },
})

require("codesnap").setup({
	save_path = "~/Pictures",
	has_breadcrumbs = true,
	has_line_number = true,
	bg_theme = "grape",
	watermark = "",
})

local map = vim.keymap.set
map("x", "<leader>cc", "<cmd>CodeSnap<cr>", { desc = "Save selected code snapshot into clipboard" })
map("x", "<leader>cs", "<cmd>CodeSnapSave<cr>", { desc = "Save selected code snapshot in ~/Pictures" })
