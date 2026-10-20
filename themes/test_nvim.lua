-- Run with XDG_CONFIG_HOME pointing at a temporary directory, never the real home.
assert(vim.env.DOTFILES_THEME_TEST == "1", "Set DOTFILES_THEME_TEST=1 and use a temporary XDG_CONFIG_HOME")
local path = vim.env.XDG_CONFIG_HOME .. "/dotfiles-theme/state.json"
vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
local function select(mode, light)
  vim.fn.writefile({ vim.json.encode({ mode = mode, light = light }) }, path)
end
local function normal_background()
  return vim.api.nvim_get_hl(0, { name = "Normal" }).bg
end
select("dark", "xcode-light")
require("config.dotfiles_theme").setup()
vim.cmd.colorscheme("dotfiles_pitch")
assert(normal_background() == 0x000000, "dark palette did not load")
select("light", "xcode-light")
assert(vim.wait(2500, function() return normal_background() == 0xffffff end, 100), "live light switch failed")
assert(vim.o.background == "light")
select("light", "ayu-light")
assert(vim.wait(2500, function() return normal_background() == 0xfcfcfc end, 100), "live Ayu switch failed")
select("dark", "ayu-light")
assert(vim.wait(2500, function() return normal_background() == 0x000000 end, 100), "live dark switch failed")
print("Neovim: dark / light / Ayu live switching OK")
