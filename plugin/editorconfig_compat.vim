" The bundled EditorConfig version expands <afile>:p for VimEnter and BufNew.
" Vim 9 raises E495 when those events have no file name.  BufNewFile,
" BufReadPost, and BufFilePost still provide full EditorConfig coverage for
" named buffers, so remove only the redundant unnamed-buffer hooks.
if exists('g:loaded_EditorConfig')
    augroup editorconfig
        autocmd! VimEnter
        autocmd! BufNew
    augroup END
endif
