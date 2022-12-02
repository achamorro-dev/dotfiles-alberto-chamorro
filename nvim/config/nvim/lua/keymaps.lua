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
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

--   Change to normal mode pressing jk fast in INSERT mode
keymap("i", "jh", "<ESC>", opts)

--   Terminal controls
keymap("t", "<esc>", [[<C-\><C-n>]], opts)

-- Save and quit faster
keymap("n", "<Leader>w", ":w<CR>", opts)
keymap("n", "<Leader>q", ":q<CR>", opts)

--   Indent in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

--   Move text and up
keymap("n", "<A-k>", ":m-2<CR>==", opts)
keymap("n", "<A-j>", ":m+<CR>==", opts)
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

--   Paste code removing the text selected
keymap("v", "p", '"_dP', opts)

----- End VIM keyamps

-- Telescope
keymap("n", "<Leader>f", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<Leader>g", "<cmd>Telescope live_grep<CR>", opts)
keymap("n", "<Leader>e", "<cmd>Telescope buffers<CR>", opts)
keymap("n", "<Leader>o", "<cmd>Telescope oldfiles<CR>", opts)
keymap("n", "<Leader>s", "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts)
keymap("n", "<Leader>k", "<cmd>Telescope keymaps<CR>", opts)
keymap("n", "<Leader>cc", "<cmd>Telescope colorscheme<CR>", opts)
keymap("n", "go", "<cmd>Telescope lsp_document_symbols<CR>", opts) -- outline

-- NVIM tree
keymap("n", "<Leader>t", ":NvimTreeToggle<CR>", opts)

-- LSP bindings
keymap("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
keymap("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
keymap("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
keymap("n", "<F2>", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
keymap("i", "<C-s>", "<Cmd>Lspsaga signature_help<CR>", opts)
keymap("n", "<Leader>ca", "<Cmd>Lspsaga code_action<CR>", opts)
keymap("v", "<Leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", opts)
keymap("n", "grn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename

-- Debugging
keymap("n", "<F5>", "<cmd>lua require'dap'.continue()<CR>", opts)
keymap("n", "<F3>", "<cmd>lua require'dap'.step_over()<CR>", opts)
keymap("n", "<F2>", "<cmd>lua require'dap'.step_into()<CR>", opts)
keymap("n", "<F12>", "<cmd>lua require'dap'.step_out()<CR>", opts)
keymap("n", "<leader>b", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
keymap("n", "<leader>B", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
keymap(
	"n",
	"<leader>lp",
	"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
	opts
)
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", opts)
keymap("n", "<leader>U", "<cmd>lua require'dapui'.toggle()<cr>", opts)
--keymap.set("n", "<leader>dt", ":lua require'dap-go'.debug_test()<CR>")

-- Fugitive
keymap("n", "<Leader>bl", "<cmd>Git blame<CR>", opts)

-- Lazygit
keymap("n", "<C-g>", "<cmd>LazyGit<CR>", opts)

-- Diffview
keymap("n", "<Leader>di", "<Cmd>DiffviewOpen<CR>", opts)

-- vim-test
keymap("n", "tf", "<Cmd>TestFile<CR>", opts)
keymap("n", "tn", "<Cmd>TestNearest<CR>", opts)
keymap("n", "ts", "<Cmd>TestSuite<CR>", opts)

-- Flutter
keymap("n", "fd", "<Cmd>FlutterDevices<CR>", opts)
keymap("n", "fr", "<Cmd>FlutterRestart<CR>", opts)
keymap("n", "frd", "<Cmd>FlutterRun --flavor development -t lib/main_development.dart<CR>", opts)
keymap("n", "frs", "<Cmd>FlutterRun --flavor staging -t lib/main_staging.dart<CR>", opts)
keymap("n", "frp", "<Cmd>FlutterRun --flavor production -t lib/main_production.dart<CR>", opts)
