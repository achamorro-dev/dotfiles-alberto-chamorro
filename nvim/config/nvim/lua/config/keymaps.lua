-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Editor
keymap("n", "<Leader>a", "gg<S-v>G", opts) -- Select all content

--   Split
keymap("n", "<Leader>h", ":vsplit<CR>", opts) -- Split horizontal
keymap("n", "<Leader>v", ":split<CR>", opts) -- Split vertical

--   Move between buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Save and quit faster
keymap("n", "<Leader>w", ":w<CR>", opts)
keymap("n", "<Leader>q", ":q<CR>", opts)
keymap("n", "<Leader>bd", ":bd<CR>", { noremap = true, silent = true, desc = "Delete current buffer" }) -- Remove current buffer

--   Move text and up
keymap("n", "<A-k>", ":m-2<CR>==", opts)
keymap("n", "<A-j>", ":m+<CR>==", opts)
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
-- keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
-- keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
