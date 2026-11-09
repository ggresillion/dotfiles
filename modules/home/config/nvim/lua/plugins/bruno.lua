vim.pack.add({
	{ src = "https://github.com/jugarpeupv/bruno.nvim" },
})

require("bruno").setup({})

-- Treesitter folds only include injected trees that are already parsed when the
-- fold cache is built, so the workbench's JSON body never gets folds. After each
-- render, parse the injections and drop the cache (it is cleared on FileType).
local function refresh_folds(buf)
	local ok, parser = pcall(vim.treesitter.get_parser, buf)
	if not ok or not parser then
		return
	end
	parser:parse(true)
	vim.api.nvim_exec_autocmds("FileType", { buffer = buf, modeline = false })
	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		vim.api.nvim_win_call(win, function()
			vim.cmd("normal! zx")
		end)
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "bruno_ui",
	callback = function(args)
		if vim.b[args.buf].bruno_folds_attached then
			return
		end
		local pending = false
		vim.b[args.buf].bruno_folds_attached = vim.api.nvim_buf_attach(args.buf, false, {
			on_lines = function(_, buf)
				if pending then
					return
				end
				pending = true
				vim.schedule(function()
					pending = false
					if vim.api.nvim_buf_is_valid(buf) then
						refresh_folds(buf)
					end
				end)
			end,
		})
	end,
})

local keymap = vim.keymap.set

keymap("n", "<leader>br", "<cmd>BrunoRun<cr>", { desc = "Run Bruno request" })
keymap("n", "<leader>bR", "<cmd>BrunoReplay<cr>", { desc = "Replay last Bruno request" })
keymap("n", "<leader>bo", "<cmd>BrunoToggle<cr>", { desc = "Toggle Bruno workbench" })
keymap("n", "<leader>be", "<cmd>BrunoEnv<cr>", { desc = "Select Bruno env" })
keymap("n", "<leader>bs", "<cmd>BrunoRequests<cr>", { desc = "Pick Bruno request" })
keymap("n", "<leader>bc", "<cmd>BrunoCopyCurl<cr>", { desc = "Copy Bruno request as curl" })
