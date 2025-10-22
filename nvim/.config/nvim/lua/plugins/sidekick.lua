vim.pack.add({
	{ src = "https://github.com/sidekick/sidekick.nvim" },
})

require("sidekick").setup({
	cli = {
		mux = {
			backend = "zellij",
			enabled = true,
		},
	},
})

local map = vim.keymap.set

map({ "n", "x", "i", "t" }, "<c-.>", function()
	require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle" })

map("n", "<leader>aa", function()
	require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle CLI" })

map("n", "<leader>as", function()
	require("sidekick.cli").select()
end, { desc = "Select CLI" })

map("n", "<leader>ad", function()
	require("sidekick.cli").close()
end, { desc = "Detach CLI Session" })

map({ "x", "n" }, "<leader>at", function()
	require("sidekick.cli").send({ msg = "{this}" })
end, { desc = "Send This" })

map("n", "<leader>af", function()
	require("sidekick.cli").send({ msg = "{file}" })
end, { desc = "Send File" })

map("x", "<leader>av", function()
	require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Send Visual Selection" })

map({ "n", "x" }, "<leader>ap", function()
	require("sidekick.cli").prompt()
end, { desc = "Sidekick Select Prompt" })

map("n", "<leader>ac", function()
	require("sidekick.cli").toggle({ name = "claude", focus = true })
end, { desc = "Sidekick Toggle Claude" })

-- Custom Tab behavior
map("n", "<tab>", function()
	if not require("sidekick").nes_jump_or_apply() then
		return "<Tab>"
	end
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })
