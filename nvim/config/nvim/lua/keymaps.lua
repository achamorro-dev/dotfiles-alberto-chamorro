local keymap = vim.api.nvim_set_keymap

local opts = { noremap = true, silent = true }

-- Map leader key
vim.g.mapleader = " "

----- Special keys
-- C : Control
-- S : Shift
-- A : Alt

-- VIM
keymap("n", "n", "nzzzv", opts) -- Center cursor to go next
keymap("n", "N", "Nzzzv", opts) -- Center cursor to go previous
keymap("n", "x", '"_x', opts) -- Don't yank with x
keymap("n", "<Leader>c", ":bd<CR>", opts) -- Remove current buffer

-- keymap("n", "+", "<C-a>", opts) -- Increment
-- keymap("n", "-", "<C-x>", opts) -- Decrement

keymap("n", "dw", "diw", opts) -- Delete the entire word
keymap("n", "cw", "ciw", opts) -- Change the entire word
keymap("n", "<Leader>a", "gg<S-v>G", opts) -- Select all content

--   Split
keymap("n", "<Leader>h", ":vsplit<CR>", opts) -- Split horizontal
keymap("n", "<Leader>v", ":split<CR>", opts) -- Split vertical

--   Move between panes with Ctrl+h/j/k/l
keymap("n", "<C-h>", ":wincmd h<CR>", opts)
keymap("n", "<C-j>", ":wincmd j<CR>", opts)
keymap("n", "<C-k>", ":wincmd k<CR>", opts)
keymap("n", "<C-l>", ":wincmd l<CR>", opts)

--   Move between buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

--   Resize with arrows
keymap("n", "<C-+>", ":resize -2<CR>", opts)
keymap("n", "<C-->", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

--   Change to normal mode pressing jk fast in INSERT mode
keymap("i", "jk", "<ESC>", opts)

--   Terminal controls
keymap("t", "<esc>", [[<C-\><C-n>]], opts)

keymap("n", "<Leader>w", ":w<CR>", opts)
keymap("n", "<Leader>q", ":q<CR>", opts)

--   Indent in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

--   Move text and up
-- FIXME
-- keymap("n", "<A-j>", ":m .+1<CR>==gi<CR>", opts)
-- keymap("n", "<A-k>", ":m .-2<CR>==gi<CR>", opts)
-- keymap("v", "<A-j>", ":m .+1<CR>==", opts)
-- keymap("v", "<A-k>", ":m .-2<CR>==", opts)
-- keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
-- keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
-- keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
-- keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

--   Paste code removing the text selected
keymap("v", "p", '"_dP', opts)

-- Telescope
keymap("n", "<Leader>f", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<Leader>g", "<cmd>Telescope live_grep<CR>", opts)
keymap("n", "<Leader>e", "<cmd>Telescope buffers<CR>", opts)
keymap("n", "<Leader>o", "<cmd>Telescope oldfiles<CR>", opts)
keymap("n", "<silent>;h", "<cmd>Telescope help_tags<CR>", opts)
keymap("n", "<silent>;;", "<cmd>Telescope resume<CR>", opts)
keymap("n", "<silent>;gb", "<cmd>Telescope git_branches<CR>", opts)

-- NVIM tree
keymap("n", "<Leader>t", ":NvimTreeToggle<CR>", opts)

-- LSP bindings
-- keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
-- keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)

-- LSP saga
keymap("n", "<C-j>", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)
keymap("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts)
keymap("n", "gd", "<Cmd>Lspsaga lsp_finder<CR>", opts)
keymap("i", "<C-k>", "<Cmd>Lspsaga signature_help<CR>", opts)
keymap("n", "gp", "<Cmd>Lspsaga preview_definition<CR>", opts)
keymap("n", "go", "<Cmd>LSoutlineToggle<CR>", opts)
keymap("n", "grn", "<Cmd>Lspsaga rename<CR>", opts)
keymap("n", "<Leader>ca", "<Cmd>Lspsaga code_action<CR>", opts)
keymap("v", "<Leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", opts)

-- Fugitive
keymap("n", "<silent>;gbl", "<cmd>Git blame<CR>", opts)

-- Lazygit
keymap("n", "<C-g>", "<cmd>LazyGit<CR>", opts)
