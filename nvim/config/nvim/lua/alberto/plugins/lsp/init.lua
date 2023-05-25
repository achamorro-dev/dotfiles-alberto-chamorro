return {
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
			{ "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{
				"hrsh7th/cmp-nvim-lsp",
				cond = function()
					return require("alberto.util").has("nvim-cmp")
				end,
			},
		},
		---@class PluginLspOpts
		opts = {
			-- options for vim.diagnostic.config()
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, prefix = "●" },
				severity_sort = true,
			},
			-- Automatically format on save
			autoformat = true,
			-- options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the LazyVim formatter,
			-- but can be also overridden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			-- LSP Server Settings
			---@type lspconfig.options
			servers = {
				jsonls = {},
				lua_ls = {
					-- mason = false, -- set to false if you don't want this server to be installed with mason
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			},
			-- you can do any additional lsp server setup here
			-- return true if you don't want this server to be setup with lspconfig
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				-- example to setup with typescript.nvim
				-- tsserver = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
		},
		---@param opts PluginLspOpts
		config = function(_, opts)
			-- setup autoformat
			require("alberto.plugins.lsp.format").autoformat = opts.autoformat
			-- setup formatting and keymaps
			require("alberto.util").on_attach(function(client, buffer)
				require("alberto.plugins.lsp.format").on_attach(client, buffer)
				require("alberto.plugins.lsp.keymaps").on_attach(client, buffer)
			end)

			-- diagnostics
			for name, icon in pairs(require("alberto.util.icons").diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end
			vim.diagnostic.config(opts.diagnostics)

			local servers = opts.servers
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- get all the servers that are available thourgh mason-lspconfig
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			end

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			if have_mason then
				mlsp.setup({ ensure_installed = ensure_installed })
				mlsp.setup_handlers({ setup })
			end
		end,
	},

	-- formatters
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason.nvim" },
		opts = function()
			local nls = require("null-ls")
			return {
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
				sources = {
					nls.builtins.formatting.fish_indent,
					nls.builtins.diagnostics.fish,
					nls.builtins.formatting.stylua,
					nls.builtins.formatting.shfmt,
					-- nls.builtins.diagnostics.flake8,
				},
			}
		end,
	},

	-- cmdline tools and lsp servers
	{
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		config = function()
			require("lspsaga").setup({
				-- keybinds for navigation in lspsaga window
				move_in_saga = { prev = "<C-k>", next = "<C-j>" },
				-- use enter to open file with finder
				finder = {
					keys = {
						expand_or_jump = "<CR>",
					},
				},
				-- use enter to open file with definition preview
				definition = {
					edit = "<CR>",
				},
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
				"angular-language-server",
				"astro-language-server",
				"css-lsp",
				"cssmodules-language-server",
				"docker-compose-language-service",
				"dockerfile-language-server",
				"emmet-ls",
				"eslint-lsp",
				"html-lsp",
				"json-lsp",
				"lua-language-server",
				"marksman",
				"kotlin-language-server",
				"typescript-language-server",
				"tailwindcss-language-server",
				"vue-language-server",
				"yaml-language-server",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},

	-- test
	{
		"vim-test/vim-test",
		keys = {
			{ "tf", "<Cmd>TestFile<CR>", mode = { "n" } },
			{ "tn", "<Cmd>TestNearest<CR>", mode = { "n" } },
			{ "ts", "<Cmd>TestSuite<CR>", mode = { "n" } },
			{ "tl", "<Cmd>TestLast<CR>", mode = { "n" } },
		},
		config = function()
			vim.api.nvim_exec(
				[[
          " Test config
          let test#strategy = "neovim"
          let test#neovim#term_position = "belowright"
          let g:test#preserve_screen = 1
          let g:ultest_use_pty = 1
          " Javascript
          let test#javascript#reactscripts#options = "--watchAll=false"
          let g:test#javascript#runner = 'jest'
          let g:test#javascript#cypress#executable = 'npx cypress run-ct'
      ]],
				false
			)

			-- vim.cmd([[
			--   augroup test
			--     autocmd!
			--     autocmd BufWrite * if test#exists() |
			--       \   TestFile |
			--       \ endif
			--   augroup END
			-- ]])
		end,
	},

	-- dap
	{
		"mfussenegger/nvim-dap",
		config = function() end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
	},

	{ import = "alberto.plugins.lsp.extras.json" },
	{ import = "alberto.plugins.lsp.extras.eslint" },
	{ import = "alberto.plugins.lsp.extras.prettier" },
	{ import = "alberto.plugins.lsp.extras.typescript" },
	{ import = "alberto.plugins.lsp.extras.java-kotlin" },
}
