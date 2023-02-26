return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-lua/popup.nvim" },
		{ "nvim-telescope/telescope-fzy-native.nvim" },
		{ "kyazdani42/nvim-web-devicons" },
		{ "nvim-telescope/telescope-file-browser.nvim" },
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
				path_display = { "smart" },
				color_devicons = true,

				file_previewer = require("telescope.previewers").vim_buffer_cat.new,
				grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
				qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			},
			pickers = {
				colorscheme = {
					enable_preview = true,
				},
				buffers = {
					sort_lastused = true,
				},
			},
		})

    local keymap = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    keymap("n", "<Leader>f", "<cmd>Telescope find_files<CR>", opts)
    keymap("n", "<Leader>g", "<cmd>Telescope live_grep<CR>", opts)
    keymap("n", "<Leader>e", "<cmd>Telescope buffers<CR>", opts)
    keymap("n", "<Leader>o", "<cmd>Telescope oldfiles<CR>", opts)
    keymap("n", "<Leader>s", "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts)
    keymap("n", "<Leader>k", "<cmd>Telescope keymaps<CR>", opts)
    keymap("n", "<Leader>cc", "<cmd>Telescope colorscheme<CR>", opts)
    keymap("n", "go", "<cmd>Telescope lsp_document_symbols<CR>", opts) -- outline
	end,
}
