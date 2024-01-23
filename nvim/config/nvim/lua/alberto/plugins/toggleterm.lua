return {
	"akinsho/nvim-toggleterm.lua",
	config = function()
		require("toggleterm").setup({
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
		})

		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, close_on_exit = true, direction = "float" })
		local lazydocker =
			Terminal:new({ cmd = "lazydocker", hidden = true, close_on_exit = true, direction = "float" })

		function lazygit_toggle()
			lazygit:toggle()
		end

		function lazydocker_toggle()
			lazydocker:toggle()
		end

		vim.keymap.set("n", "<leader>gg", lazygit_toggle, { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>dd", lazydocker_toggle, { noremap = true, silent = true })
	end,
}
