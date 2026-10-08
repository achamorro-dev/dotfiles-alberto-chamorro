-- VS Code: ctrl+n = add selection to next find match (multi-cursor)
return {
  "mg979/vim-visual-multi",
  keys = {
    { "<C-n>", mode = { "n", "x" } },
    { "<C-Down>", mode = { "n", "x" } },
    { "<C-Up>", mode = { "n", "x" } },
  },
}
