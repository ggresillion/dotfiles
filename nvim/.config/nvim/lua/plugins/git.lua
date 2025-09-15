return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				-- Navigation
				vim.keymap.set("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { buffer = bufnr, desc = "Next Git hunk" })

				vim.keymap.set("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { buffer = bufnr, desc = "Prev Git hunk" })
			end,
		},
		keys = {
			-- Actions
			{ "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk" },
			{ "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk" },
			{
				"<leader>gs",
				function()
					require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
				mode = "v",
				desc = "Stage selection",
			},
			{
				"<leader>gr",
				function()
					require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
				mode = "v",
				desc = "Reset selection",
			},
			{ "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage buffer" },
			{ "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset buffer" },
			{ "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
			{ "<leader>gi", "<cmd>Gitsigns preview_hunk_inline<cr>", desc = "Preview hunk inline" },
			{
				"<leader>gb",
				function()
					require("gitsigns").blame_line({ full = true })
				end,
				desc = "Blame line",
			},
			{ "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff this" },
			{
				"<leader>gD",
				function()
					require("gitsigns").diffthis("~")
				end,
				desc = "Diff against ~",
			},
			{
				"<leader>gQ",
				function()
					require("gitsigns").setqflist("all")
				end,
				desc = "Send all hunks to quickfix",
			},
			{
				"<leader>gq",
				function()
					require("gitsigns").setqflist()
				end,
				desc = "Send hunks to quickfix",
			},

			-- Toggles
			{ "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle blame line" },
			{ "<leader>gw", "<cmd>Gitsigns toggle_word_diff<cr>", desc = "Toggle word diff" },

			-- Text object
			{ "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Select hunk" },
		},
	},
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		config = function()
			require("diffview").setup({
				use_icons = true, -- set to false if you want a minimalist UI
			})
		end,
		keys = {},
	},
}
