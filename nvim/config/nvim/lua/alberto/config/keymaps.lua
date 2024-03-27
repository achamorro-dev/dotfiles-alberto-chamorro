local keymap = vim.keymap.set

local opts = { noremap = true, silent = true }

----- Special keys
-- C : Control
-- S : Shift
-- A : Alt

-- VIM
keymap("n", "n", "nzzzv", opts) -- Center cursor to go next
keymap("n", "N", "Nzzzv", opts) -- Center cursor to go previous
keymap("n", "x", '"_x', opts) -- Don't yank with x

keymap("n", "+", "<C-a>", opts) -- Increment
keymap("n", "-", "<C-x>", opts) -- Decrement

keymap("n", "dw", "diw", opts) -- Delete the entire word
keymap("n", "cw", "ciw", opts) -- Change the entire word
keymap("n", "yw", "yiw", opts) -- Copy the entire word
keymap("n", "<Leader>a", "gg<S-v>G", opts) -- Select all content

--   Split
keymap("n", "<Leader>h", ":vsplit<CR>", opts) -- Split horizontal
keymap("n", "<Leader>v", ":split<CR>", opts) -- Split vertical

--   Move between panes with Ctrl+h/j/k/l
-- Use vim-tmux-navigator instead
-- keymap("n", "<C-h>", ":wincmd h<CR>", opts)
-- keymap("n", "<C-j>", ":wincmd j<CR>", opts)
-- keymap("n", "<C-k>", ":wincmd k<CR>", opts)
-- keymap("n", "<C-l>", ":wincmd l<CR>", opts)

--   Move between buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

--   Resize with arrows
keymap("n", "<C-+>", ":resize -2<CR>", opts)
keymap("n", "<C-->", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

--   Change to normal mode pressing jk fast in INSERT mode
keymap("i", "jh", "<ESC>", opts)

--   Terminal controls
-- keymap("t", "<esc>", [[<C-\><C-n>]], opts)

-- Save and quit faster
keymap("n", "<Leader>w", ":w<CR>", opts)
keymap("n", "<Leader>q", ":q<CR>", opts)
keymap("n", "<Leader>c", ":bd<CR>", opts) -- Remove current buffer
keymap("n", "<Leader>bd", ":bd!<CR>", opts) -- Force remove current buffer

--   Indent in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

--   Move text and up
keymap("n", "<A-k>", ":m-2<CR>==", opts)
keymap("n", "<A-j>", ":m+<CR>==", opts)
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
-- keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
-- keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

--   Paste code removing the text selected
keymap("v", "p", '"_dP', opts)

----- End VIM keyamps
