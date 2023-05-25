return {
	-- todo comments
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = { "BufReadPost", "BufNewFile" },
		config = true,
		keys = {
			{ "T", "<cmd>TodoTelescope<cr>" },
		},
	},
	{
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
		keys = {
			{ "<Leader>f", "<cmd>Telescope find_files<CR>" },
			{ "<Leader>g", "<cmd>Telescope live_grep<CR>" },
			{ "<Leader>e", "<cmd>Telescope buffers<CR>" },
			{ "<Leader>o", "<cmd>Telescope oldfiles<CR>" },
			{ "<Leader>s", "<cmd>Telescope current_buffer_fuzzy_find<CR>" },
			{ "<Leader>k", "<cmd>Telescope keymaps<CR>" },
			{ "<Leader>sd", "<cmd>Telescope diagnostics<CR>" },
			{ "<Leader>cc", "<cmd>Telescope colorscheme<CR>" },
			{ "go", "<cmd>Telescope lsp_document_symbols<CR>" }, -- outline
		},
		config = function()
			local telescope = require("telescope")
			local telescope_icons = require("alberto.util.icons").telescope
			telescope.setup({
				defaults = {
					file_sorter = require("telescope.sorters").get_fzy_sorter,
					prompt_prefix = telescope_icons.default,
					selection_caret = telescope_icons.selection_caret,
					color_devicons = true,
					file_previewer = require("telescope.previewers").vim_buffer_cat.new,
					grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
					qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
					layout_config = {
						preview_width = 0.5,
					},
					path_display = { "truncate" },
				},
				pickers = {
					colorscheme = {
						enable_preview = true,
					},
					buffers = {
						sort_lastused = true,
						prompt_prefix = telescope_icons.buffers,
					},
					commands = {
						prompt_prefix = " ",
					},
					git_files = {
						prompt_prefix = " ",
						show_untracked = true,
					},
					find_files = {
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
					lsp_document_symbols = {
						symbols = {
							"Class",
							"Function",
							"Method",
							"Constructor",
							"Interface",
							"Module",
							"Struct",
							"Trait",
							"Field",
							"Property",
						},
					},
				},
			})
		end,
	},
}
