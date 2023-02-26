local options = vim.o

vim.g.mapleader = " "

options.relativenumber = false
options.number = true
options.ruler = true
options.splitright = true
options.splitbelow = true
options.smarttab = true
options.expandtab = true
options.tabstop = 2
options.softtabstop = 2
options.shiftwidth = 2
options.autoindent = true
options.smartindent = true
options.autoread = true
options.title = true
options.termguicolors = true
options.hidden = true
options.encoding = "utf-8"
options.fileencoding = "utf-8"
options.clipboard = "unnamedplus"
options.swapfile = false
options.laststatus = 3
options.ignorecase = true
options.smartcase = true
options.hlsearch = true
options.incsearch = true
options.splitbelow = true
options.splitright = true
options.autowrite = true
options.mouse = "a"
options.cursorline = true
options.cmdheight = 0

-- consider string-string as whole word
-- options.iskeyword:append("-")

-- Stop comments on newline
vim.cmd("autocmd BufWinEnter * :set formatoptions-=c formatoptions-=r formatoptions-=o")
