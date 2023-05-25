return {
	"akinsho/nvim-toggleterm.lua",
	opts = {
		size = 15,
		open_mapping = "<F1>",
		hide_numbers = true,
		shade_filetypes = {},
		shade_terminals = true,
		shading_factor = 1,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "horizontal",
		close_on_exit = true,
		shell = vim.o.shell, -- change the default shell
	},
	-- keys = {
	-- 	{ "<Leader>d", "<cmd>TermExec cmd='lazydocker' direction=vertical hidden=true<CR>" },
	-- },
}
