local status_ok, _ = pcall(require, "dap")
if not status_ok then
	return
end

require("plugins.dap.dap-ui")
require("plugins.dap.dap-virtual-text")
require("plugins.dap.dap-vscode-js")
