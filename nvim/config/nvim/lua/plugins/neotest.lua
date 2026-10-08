-- Test keymaps aligned with VS Code keybindings.json (t a/f/n/l/d)
local function dart_go_to_test_or_impl()
  if vim.bo.filetype ~= "dart" then
    return
  end
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    return
  end
  local target
  if path:match("_test%.dart$") then
    target = path:gsub("_test%.dart$", ".dart"):gsub("/test/", "/lib/")
  else
    target = path:gsub("%.dart$", "_test.dart"):gsub("/lib/", "/test/")
  end
  if target ~= path and vim.uv.fs_stat(target) then
    vim.cmd.edit(vim.fn.fnameescape(target))
  else
    vim.notify("No test/implementation file found for:\n" .. path, vim.log.levels.WARN)
  end
end

return {
  {
    "nvim-neotest/neotest",
    keys = {
      -- VS Code: t t = go to test/implementation file (Dart)
      { "<leader>tt", dart_go_to_test_or_impl, desc = "Go to Test/Impl (Dart)" },
      -- VS Code: t a = run all tests
      {
        "<leader>ta",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Run All Test Files",
      },
      {
        "<leader>tA",
        function()
          require("neotest").run.attach()
        end,
        desc = "Attach to Test",
      },
      -- VS Code: t f / t n
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File",
      },
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      { "<leader>tr", false },
      { "<leader>tT", false },
    },
  },
}
