return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    local flavour = vim.env.THEME_FLAVOUR
    require("catppuccin").setup({
      flavour = flavour,
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
