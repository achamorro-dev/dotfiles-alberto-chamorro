return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- use 'glepnir/dashboard-nvim'

	-- Themes
	use("navarasu/onedark.nvim")
	use("arzg/vim-colors-xcode")

	-- IDE
	-- Language server protocol
	-- Completion
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-git",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind-nvim",
			"L3MON4D3/LuaSnip",
			"windwp/nvim-autopairs",
			"rafamadriz/friendly-snippets",
		},
	})

	-- Error lens
	-- use("https://git.sr.ht/~whynothugo/lsp_lines.nvim")

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"jose-elias-alvarez/null-ls.nvim",
		"glepnir/lspsaga.nvim",
	})

	-- Instalation of LSP/Debuggers/Formatters/Other
	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	})

	-- TypeScript tools
	use("jose-elias-alvarez/typescript.nvim")

	-- Syntax highlight
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
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

	-- Tabs
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
end)
