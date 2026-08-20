" Personal appearance and usability overrides.  This file is sourced last.
scriptencoding utf-8

" ---------------------------------------------------------------------------
" Persistence and privacy
" ---------------------------------------------------------------------------
" Reused from the backup branch: CtrlP owns MRU history, Markdown starts
" unfolded, and copied/deleted text is not persisted in ~/.viminfo.
let g:vim_markdown_folding_disabled = 1
let g:netrw_dirhistmax = 0
set viminfo='50,<0,s10,h,:100,/100,@50

if has('clipboard')
    set clipboard=unnamedplus
endif

" Persistent undo is valuable for source files but should not retain old
" credential contents after the original file changes.
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

" ---------------------------------------------------------------------------
" Appearance
" ---------------------------------------------------------------------------
if exists('+termguicolors')
    set termguicolors
endif

set background=dark
let g:molokai_original = 1
silent! colorscheme molokai

set number
set norelativenumber
set cursorline
if exists('+cursorlineopt')
    set cursorlineopt=number,line
endif
if exists('+signcolumn')
    set signcolumn=yes
endif
set colorcolumn=100
set laststatus=2
set showtabline=2
set noshowmode
set showcmd
set cmdheight=1

" Quiet end-of-buffer markers and make window boundaries easy to scan.
if exists('+fillchars')
    let &fillchars = 'vert:│,fold:·,foldopen:-,foldclose:+,foldsep:│,diff:╱,eob: '
endif
set listchars=tab:»\ ,trail:·,extends:›,precedes:‹,nbsp:+

" Keep a subtle, theme-matched visual hierarchy even when true color is used.
highlight clear SignColumn
highlight link SignColumn LineNr
highlight clear VertSplit
highlight link VertSplit LineNr

" ---------------------------------------------------------------------------
" Editing and navigation
" ---------------------------------------------------------------------------
set mouse=a
set splitbelow
set splitright
set confirm
set nostartofline
set virtualedit=block
set sidescrolloff=5
set scrolloff=5
set nowrap
set linebreak
set breakindent
set textwidth=0
set foldlevelstart=99
set nofoldenable
set nrformats-=octal

set completeopt=menuone,noselect
if exists('+pumheight')
    set pumheight=12
endif
set wildmode=longest:full,full
if exists('+wildoptions')
    set wildoptions=pum
endif
set wildignore+=*/node_modules/*,*/dist/*,*/build/*,*/.cache/*
set wildignore+=*/.venv/*,*/venv/*,*/__pycache__/*,*/.pytest_cache/*
set wildignore+=*/.mypy_cache/*,*/.ruff_cache/*,*/.tox/*,*/htmlcov/*,*.egg-info/*

set updatetime=300
set timeoutlen=400
set ttimeout
set ttimeoutlen=10
set shortmess+=c
if exists('+inccommand')
    set inccommand=nosplit
endif
if exists('+diffopt')
    set diffopt+=vertical
endif

" Restore crash recovery without leaving swap files next to source files.
let s:swap_dir = expand('~/.vim_runtime/temp_dirs/swap')
if !isdirectory(s:swap_dir)
    call mkdir(s:swap_dir, 'p')
endif
let s:swap_option = s:swap_dir . '//'
if index(split(&directory, ','), s:swap_option) < 0
    let &directory = s:swap_option . ',' . &directory
endif
set swapfile

" Move by screen line when wrapping is enabled, while preserving counted j/k.
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <silent> <leader><space> :CtrlP<CR>
nnoremap <silent> <leader>sv :source ~/.vim_runtime/my_configs.vim<CR>:redraw<CR>:echo 'Personal Vim config reloaded'<CR>
nnoremap <silent> <leader>ul :set list!<CR>:set list?<CR>
nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Down> :resize -2<CR>
nnoremap <silent> <C-Left> :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>
xnoremap < <gv
xnoremap > >gv
if exists(':terminal') == 2
    tnoremap <Esc><Esc> <C-\><C-n>
endif

" ---------------------------------------------------------------------------
" Context-aware UI
" ---------------------------------------------------------------------------
augroup personal_ui
    autocmd!
    autocmd WinEnter,BufEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline

    " Utility buffers should stay compact and free of editing-only chrome.
    autocmd FileType help,qf,nerdtree,ctrlp setlocal nonumber norelativenumber nocursorline signcolumn=no colorcolumn=

    " Do not continue comment leaders automatically on a new line.
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

augroup END
