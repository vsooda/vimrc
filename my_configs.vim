" Personal appearance and usability overrides.  This file is sourced last.
scriptencoding utf-8

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
set relativenumber
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
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Down> :resize -2<CR>
nnoremap <silent> <C-Left> :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>
xnoremap < <gv
xnoremap > >gv
if exists(':terminal') == 2
    tnoremap <Esc><Esc> <C-\><C-n>
endif

let g:personal_relative_numbers = get(g:, 'personal_relative_numbers', 1)
function! PersonalToggleRelativeNumbers() abort
    let g:personal_relative_numbers = !g:personal_relative_numbers
    if g:personal_relative_numbers && mode() !=# 'i'
        setlocal relativenumber
    else
        setlocal norelativenumber
    endif
    setlocal relativenumber?
endfunction
nnoremap <silent> <leader>un :call PersonalToggleRelativeNumbers()<CR>

" ---------------------------------------------------------------------------
" Context-aware UI
" ---------------------------------------------------------------------------
augroup personal_ui
    autocmd!
    " Hybrid line numbers: relative while navigating, absolute while typing.
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if g:personal_relative_numbers && &l:number | setlocal relativenumber | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave * if &l:number | setlocal norelativenumber | endif
    autocmd WinEnter,BufEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline

    " Utility buffers should stay compact and free of editing-only chrome.
    autocmd FileType help,qf,nerdtree,ctrlp setlocal nonumber norelativenumber nocursorline signcolumn=no colorcolumn=

    " Do not continue comment leaders automatically on a new line.
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

augroup END
