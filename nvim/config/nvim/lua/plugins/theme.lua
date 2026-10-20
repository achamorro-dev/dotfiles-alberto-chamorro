return {
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "dotfiles_pitch" },
    init = function()
      require("config.dotfiles_theme").setup()
    end,
  },
}
