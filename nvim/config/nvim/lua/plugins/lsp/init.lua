local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("typescript")
require("plugins.lsp.mason")
require("plugins.lsp.lsp")
require("plugins.lsp.null-ls")
require("plugins.lsp.lspsaga")
