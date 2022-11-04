local status_ok, telescope  = pcall(require, "telescope")
if not status_ok then
	return
end

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
		buffers = {
			sort_lastused = true,
		},
	},
})

-- require('telescope').load_extension('fzf')
-- require('telescope').load_extension('media_files')
require("telescope").load_extension("flutter")
