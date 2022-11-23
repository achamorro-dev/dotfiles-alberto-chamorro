local status_ok, dapvirtualtext = pcall(require, "nvim-dap-virtual-text")
if not status_ok then
	return
end

dapvirtualtext.setup()
