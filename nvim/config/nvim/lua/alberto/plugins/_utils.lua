return {
  "samjwill/vim-auto-nohlsearch",
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
}
