return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-lua/popup.nvim" },
		{ "nvim-telescope/telescope-fzy-native.nvim" },
		{ "kyazdani42/nvim-web-devicons" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				file_sorter = require("telescope.sorters").get_fzy_sorter,
				prompt_prefix = "  ",
				selection_caret = " ",
				path_display = { "truncate" },
				color_devicons = true,
				file_previewer = require("telescope.previewers").vim_buffer_cat.new,
				grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
				qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			},
			pickers = {
				colorscheme = {
					enable_preview = true,
					theme = "dropdown",
				},
				buffers = {
					sort_lastused = true,
					hidden = true,
					previewer = false,
					theme = "dropdown",
				},
				find_files = {
					hidden = true,
					previewer = false,
					theme = "dropdown",
				},
				live_grep = {
					hidden = true,
					theme = "dropdown",
				},
				current_buffer_fuzzy_find = {
					hidden = true,
					theme = "dropdown",
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		})

		require("telescope").load_extension("ui-select")

		local keymap = vim.keymap.set
		local opts = { noremap = true, silent = true }

		keymap("n", "<Leader>f", "<cmd>Telescope find_files<CR>", opts)
		keymap("n", "<Leader>g", "<cmd>Telescope live_grep<CR>", opts)
		keymap("n", "<Leader>e", "<cmd>Telescope buffers<CR>", opts)
		keymap("n", "<Leader>d", "<cmd>Telescope oldfiles<CR>", opts)
		keymap("n", "<Leader>s", "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts)
		keymap("n", "<Leader>k", "<cmd>Telescope keymaps<CR>", opts)
		keymap("n", "<Leader>cc", "<cmd>Telescope colorscheme<CR>", opts)
		keymap("n", "go", "<cmd>Telescope lsp_document_symbols<CR>", opts) -- outline
	end,
}
