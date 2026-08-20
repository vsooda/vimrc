" Keep Markdown files fully expanded when opened.  The vim-markdown plugin
" otherwise installs a header-based fold expression, which closes sections at
" Vim's default fold level.
let g:vim_markdown_folding_disabled = 1

" Avoid duplicate recent-file databases.  CtrlP already provides MRU search,
" so skip the standalone MRU plugin and keep the existing <leader>f workflow.
let loaded_mru = 1
nnoremap <silent> <leader>f :CtrlPMRUFiles<CR>
let g:ctrlp_mruf_max = 100

" Keep useful command/search history, but do not persist copied or deleted text
" in ~/.viminfo.  In-memory history remains controlled by 'history'.
set viminfo='50,<0,s10,h,:100,/100,@50

" Do not create ~/.netrwhist when Vim's built-in file browser is used.
let g:netrw_dirhistmax = 0

" Persistent undo is useful for source and documentation files, but it can
" retain old contents from credentials long after the original file changes.
function! s:DisablePersistentUndoForSensitiveFile(path) abort
    let l:path = simplify(fnamemodify(a:path, ':p'))
    let l:name = fnamemodify(l:path, ':t')

    let l:sensitive_dir = '/\.\%(aws\|claude\|codex\|docker\|gnupg\|kube\|ssh\)/'
    let l:sensitive_name = '^\%(\.env\%(\..*\)\?\|\.git-credentials\|\.netrc\|\.npmrc\|\.pypirc\|credentials\?\%(\..*\)\?\|keys\?\%(\..*\)\?\|secrets\?\%(\..*\)\?\|tokens\?\%(\..*\)\?\)$'

    if l:path =~# l:sensitive_dir
                \ || l:path =~# '/\.config/gcloud/'
                \ || l:name =~? l:sensitive_name
                \ || l:name =~? '\.\%(key\|pem\|p12\|pfx\)$'
        setlocal noundofile
    endif
endfunction

augroup private_files_no_persistent_undo
    autocmd!
    autocmd BufReadPre,BufNewFile * call <SID>DisablePersistentUndoForSensitiveFile(expand('<afile>'))
augroup END

nnoremap <F9> :exe 'NERDTreeToggle'<CR>
"set pastetoggle=<F2>
"for easy copy 
set mouse=

"set guifont=Ubuntu\ Mono\ 12

"for outside paste mistake
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>
"let Tlist_Use_Split_Window = 1
"sudo apt-get install ncurses-term
"export TERM=xterm-256color(.bashrc)
"let g:rehash256 = 1
:set nu
" [set nu!] to close the line number
"colorscheme monokai
colorscheme molokai
let g:molokai_original = 1

"filetype plugin indent on
"autocmd FileType python setlocal et sta sw=2 sts=2
"let NERDTreeWinPos='left'

"vertical indent, use <leader>ig to activatee
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size=1
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  guibg=darkgrey   ctermbg=darkgrey
hi IndentGuidesEven guibg=darkgrey ctermbg=darkgrey
inoremap {} {<esc>o}<esc>O
"map <leader>1 :tabnext 1<CR>
"map <leader>2 :tabnext 2<CR>
"map <leader>3 :tabnext 3<CR>
"map <leader>4 :tabnext 4<CR>
"map <leader>5 :tabnext 5<CR>
"map <leader>6 :tabnext 6<CR>
"highlight OverLength ctermbg=red ctermfg=white guibg=#592929 
"match OverLength /\%81v.\+/
"

" temporary change auto incident in some file which the incidient is not  4
map <leader>2 :set shiftwidth=2 tabstop=2<CR>
map <leader>3 :set shiftwidth=3 tabstop=3<CR>
map <leader>4 :set shiftwidth=4 tabstop=4<CR>

"syntastic check setting
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes':   [],'passive_filetypes': [] }
"close the error msg
map <leader>c :lclose<CR>
"check manually
noremap <leader>e :SyntasticCheck<CR>
"enable or disable the checker
noremap <leader>s :SyntasticToggleMode<CR>

"for vim system clipboard
set clipboard=unnamedplus

" mac

"set clipboard=unnamed
"let g:clang_library_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/'
