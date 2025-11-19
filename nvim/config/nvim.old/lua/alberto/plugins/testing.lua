return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"vim-test/vim-test",
		"nvim-neotest/neotest-jest",
		"nvim-neotest/neotest-plenary",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		require("neotest").setup({
			status = {
				enabled = true,
				signs = true,
				virtual_text = true,
			},
			adapters = {
				require("neotest-plenary"),
			},
		})

		vim.api.nvim_exec(
			[[
          " Test config
          let test#strategy = "neovim"
          let test#neovim#term_position = "belowright"
          let g:test#preserve_screen = 1
          let g:ultest_use_pty = 1
      ]],
			false
		)

		vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", {})
		vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", {})
		vim.keymap.set("n", "<leader>ta", ":TestSuite<CR>", {})
		vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", {})
	end,
}
