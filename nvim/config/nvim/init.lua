-- ensures packer is installed
local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	execute("packadd packer.nvim")
end

vim.opt.termguicolors = true

require("plugins")
require("plugins.onedark")
require("plugins.autopairs")
require("plugins.colorizer")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.flutter")
require("plugins.lsp")
require("plugins.toggleterm")
require("plugins.nvim-tree")
require("plugins.comment")
require("plugins.gitsigns")
require("plugins.lualine")
require("plugins.bufferline")
require("plugins.cmp")
require("plugins.diffview")
require("plugins.highlightedyank")
require("plugins.vim-test")

require("settings")
require("keymaps")
require("autocommands")
