vim.filetype.add({
	pattern = {
		[".*"] = function(path, bufnr)
			if vim.bo[bufnr].filetype ~= "" then
				return
			end

			local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
			if first_line:match("^%s*[{%[]") then
				return "json"
			end
		end,
	},
})
