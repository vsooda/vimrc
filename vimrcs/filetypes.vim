" Language-specific settings that are still used by this configuration.
augroup language_specific_settings
    autocmd!

    autocmd FileType python syntax keyword pythonDecorator True None False self
    autocmd FileType python nnoremap <buffer> F :setlocal foldmethod=indent<cr>
    autocmd FileType python inoremap <buffer> $r return<Space>
    autocmd FileType python inoremap <buffer> $i import<Space>
    autocmd FileType python inoremap <buffer> $p print<Space>
    autocmd FileType python inoremap <buffer> $f # ---<Space><esc>a
    autocmd FileType python nnoremap <buffer> <leader>1 /class<Space>
    autocmd FileType python nnoremap <buffer> <leader>2 /def<Space>
    autocmd FileType python nnoremap <buffer> <leader>C ?class<Space>
    autocmd FileType python nnoremap <buffer> <leader>D ?def<Space>

    autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
    autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END
