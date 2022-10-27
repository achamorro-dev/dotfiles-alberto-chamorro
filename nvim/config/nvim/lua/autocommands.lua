vim.cmd([[

  augroup _lsp
    autocmd!
    autocmd BufRead,BufEnter *.astro set filetype=astro

  augroup end


]])
