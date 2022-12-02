-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

return packer.startup(function(use)
	use("wbthomason/packer.nvim")

	-- use 'glepnir/dashboard-nvim'

	-- Themes
	-- use("navarasu/onedark.nvim")
	-- use("arzg/vim-colors-xcode")
	use("EdenEast/nightfox.nvim")
	use("marko-cerovac/material.nvim")
	use({
		"catppuccin/nvim",
		as = "catppuccin",
		config = function()
			require("catppuccin").setup()
		end,
	})

	-- IDE
	-- Add, delete or change surroundings
	use("tpope/vim-surround")
	-- Replace with clipboard using gr<motion>
	use("vim-scripts/ReplaceWithRegister")

	-- Completion and snippets
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			{ "L3MON4D3/LuaSnip", tag = "v1.*" },
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	})

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"jose-elias-alvarez/null-ls.nvim",
		"glepnir/lspsaga.nvim",
		"onsails/lspkind.nvim",
	})

	-- Installation of LSP/Debuggers/Formatters/Other
	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"jayp0521/mason-null-ls.nvim",
	})

	-- Debugging
	use("mfussenegger/nvim-dap")
	use("rcarriga/nvim-dap-ui")
	use("theHamsta/nvim-dap-virtual-text")
	use("nvim-telescope/telescope-dap.nvim")
	-- 	use({
	-- 		"mfussenegger/nvim-dap",
	-- 		opt = true,
	-- 		event = "BufReadPre",
	-- 		module = { "dap" },
	-- 		wants = { "nvim-dap-virtual-text", "nvim-dap-ui" },
	-- 		requires = {
	-- 			"theHamsta/nvim-dap-virtual-text",
	-- 			"rcarriga/nvim-dap-ui",
	-- 			"nvim-telescope/telescope-dap.nvim",
	-- 			{ "jbyuki/one-small-step-for-vimkind", module = "osv" },
	-- 		},
	-- 		-- config = function()
	-- 			-- require("plugins.dap").setup()
	-- 		-- end,
	-- 	})
	use({ "mxsdev/nvim-dap-vscode-js" })

	-- Test runner
	use({ "vim-test/vim-test" })

	-- TypeScript tools
	use("jose-elias-alvarez/typescript.nvim")

	-- Syntax highlight
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	})

	use("norcalli/nvim-colorizer.lua")

	-- Auto open-close blocks
	use("windwp/nvim-autopairs")
	use("windwp/nvim-ts-autotag")

	-- Comment blocks
	-- use 'terrortylor/nvim-comment'
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Multicursor
	use("mg979/vim-visual-multi")

	-- Git
	use("tpope/vim-fugitive")
	use("kdheepak/lazygit.nvim")
	use({
		"sindrets/diffview.nvim",
		requires = "nvim-lua/plenary.nvim",
	})

	-- Show git changes flags
	use({
		"lewis6991/gitsigns.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})

	-- Autosave
	--use({ 'Pocco81/auto-save.nvim',
	--    config = function()
	--        require('auto-save').setup({
	--            enabled = true,
	--            execution_message = 'AutoSave: saved at ' .. vim.fn.strftime('%H:%M:%S'),
	--            events = {'InsertLeave', 'TextChanged'},
	--            conditions = {
	--                exists = true,
	--                modifiable = true
	--            },
	--            write_all_buffers = false,
	--            on_off_commands = true,
	--            clean_command_line_interval = 0,
	--            debounce_delay = 135
	--        })
	--    end
	--})

	-- File tabs
	use({
		"akinsho/nvim-bufferline.lua",
		requires = "kyazdani42/nvim-web-devicons",
	})

	-- Markdown preview
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})

	-- Highlight on yank
	use("machakann/vim-highlightedyank")

	-- Toggleterm
	use("akinsho/nvim-toggleterm.lua")

	-- File finder with superpowers
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-media-files.nvim",
		},
	})

	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "make",
	})

	-- File explorer
	use({
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
	})

	-- Extras
	use({
		"hoob3rt/lualine.nvim",
		requires = {
			"kyazdani42/nvim-web-devicons",
			opt = true,
		},
	})

	-- Flutter
	use({ "akinsho/flutter-tools.nvim", requires = "nvim-lua/plenary.nvim" })

	if packer_bootstrap then
		require("packer").sync()
	end
end)
