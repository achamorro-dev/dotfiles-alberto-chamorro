vim.api.nvim_exec(
	[[
        " Test config
        let test#strategy = "neovim"
        let test#neovim#term_position = "belowright"
        let g:test#preserve_screen = 1
        let g:ultest_use_pty = 1
        " Javascript
        let test#javascript#reactscripts#options = "--watchAll=false"
        let g:test#javascript#runner = 'jest'
        let g:test#javascript#cypress#executable = 'npx cypress run-ct'
    ]],
	false
)

-- vim.cmd([[
--   augroup test
--     autocmd!
--     autocmd BufWrite * if test#exists() |
--       \   TestFile |
--       \ endif
--   augroup END
-- ]])
