local ok, mason = pcall(require, "mason")
if not ok then
	return
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	return
end

local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
	return
end

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

mason_null_ls.setup({
	ensure_installed = {
		"prettier",
		"stylua",
		"eslint_d",
	},
	automatic_installation = true,
})
