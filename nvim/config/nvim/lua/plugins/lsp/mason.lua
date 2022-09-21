local ok, mason = pcall(require, "mason")
if not ok then
	return
end

local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local servers = {
	"angularls",
	"astro",
	"bashls",
	"cssls",
	"cssmodules_ls",
	"dockerls",
	"dotls",
	"eslint",
	"emmet_ls",
	"html",
	"jdtls",
	"jsonls",
	"marksman",
	"rust_analyzer",
	"sumneko_lua",
	"svelte",
	"tsserver",
	"tailwindcss",
	"vuels",
	"yamlls",
}

mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

mason_lspconfig.setup({
	automatic_installation = true,
	ensure_installed = servers,
})

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("plugins.lsp.lsp").on_attach,
		capabilities = require("plugins.lsp.lsp").capabilities,
	}
	local has_custom_opts, server_custom_opts = pcall(require, "plugins.lsp.configs." .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
	end
	lspconfig[server].setup(opts)
end
