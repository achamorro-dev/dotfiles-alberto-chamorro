vim.cmd([[

  augroup _lsp
    autocmd!
    autocmd BufWritePre * lua vim.lsp.buf.formatting_seq_sync()
  augroup end


]])
