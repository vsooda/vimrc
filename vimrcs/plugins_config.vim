"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important:
"       This requires that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" => Enable native vim packages as described in the README
""""""""""""""""""""""""""""""
set packpath+=~/.vim_runtime


""""""""""""""""""""""""""""""
" => Load pathogen paths
""""""""""""""""""""""""""""""
let s:vim_runtime = expand('<sfile>:p:h')."/.."
call pathogen#infect(
      \ s:vim_runtime.'/sources_non_forked/{}',
      \ s:vim_runtime.'/my_plugins/{}')
" Help tags are generated when plugins change, not on every startup.
" Run :Helptags manually after adding or updating a plugin.


""""""""""""""""""""""""""""""
" => YankStack
""""""""""""""""""""""""""""""
let g:yankstack_yank_keys = ['y', 'd']

nmap <C-p> <Plug>yankstack_substitute_older_paste
nmap <C-n> <Plug>yankstack_substitute_newer_paste


""""""""""""""""""""""""""""""
" => CTRL-P
""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 0

" Quickly find and open a file in the current working directory
let g:ctrlp_map = '<C-f>'
nnoremap <silent> <leader>j :CtrlP<cr>

" Quickly find and open a buffer
nnoremap <silent> <leader>b :CtrlPBuffer<cr>

" Reuse CtrlP for recent files instead of maintaining a second MRU database.
nnoremap <silent> <leader>f :CtrlPMRUFiles<cr>
let g:ctrlp_mruf_max = 100

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|__pycache__\|\.venv\|venv\|^\.DS_Store\|^\.git'

" Let Git or ripgrep enumerate files instead of Vim's slower recursive glob.
if executable('rg')
    let g:ctrlp_user_command = {
          \ 'types': {
          \   1: ['.git', 'cd %s && git ls-files -co --exclude-standard']
          \ },
          \ 'fallback': 'cd %s && rg --files --hidden --glob "!.git"',
          \ 'ignore': 0
          \ }
    let g:ctrlp_use_caching = 0
elseif executable('git')
    let g:ctrlp_user_command =
          \ ['.git', 'cd %s && git ls-files -co --exclude-standard']
endif


""""""""""""""""""""""""""""""
" => snipMate (beside <TAB> support <CTRL-j>)
""""""""""""""""""""""""""""""
" Copilot owns <Tab>; use Ctrl-J/K for snippet navigation without causing the
" two plugins to fight over the same mapping during startup.
let g:snips_no_mappings = 1
imap <C-j> <Plug>snipMateNextOrTrigger
smap <C-j> <Plug>snipMateSNext
imap <C-k> <Plug>snipMateBack
smap <C-k> <Plug>snipMateBack
let g:snipMate = { 'snippet_version' : 1 }


""""""""""""""""""""""""""""""
" => Project search (ripgrep + vim-grepper)
""""""""""""""""""""""""""""""
let g:grepper = {
      \ 'tools': ['rg', 'git', 'grep'],
      \ 'dir': 'repo,file',
      \ 'highlight': 1,
      \ 'searchreg': 1,
      \ 'rg': {
      \   'grepprg': 'rg -H --no-heading --vimgrep --smart-case --hidden --glob !.git'
      \ }
      \ }
" Grepper chooses the first available tool, falling back from rg to git/grep.
nnoremap <silent> <leader>g :Grepper<CR>
xmap <silent> <leader>g <Plug>(GrepperOperator)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden=0
let NERDTreeIgnore = [
      \ '\.pyc$',
      \ '__pycache__$',
      \ '^node_modules$',
      \ '^venv$',
      \ '\.egg-info$'
      \ ]
let g:NERDTreeWinSize=35
nnoremap <silent> <leader>nn :NERDTreeToggle<cr>
nnoremap <leader>nb :NERDTreeFromBookmark<Space>
nnoremap <silent> <leader>nf :NERDTreeFind<cr>
nnoremap <silent> <F9> :NERDTreeToggle<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-visual-multi
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-s>'
let g:VM_maps['Find Subword Under'] = '<C-s>'
let g:VM_maps['Select All'] = '<M-s>'
let g:VM_maps['Visual All'] = '<M-s>'
let g:VM_maps['Add Cursor Down'] = '<M-C-Down>'
let g:VM_maps['Add Cursor Up'] = '<M-C-Up>'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
" Annotate strings with gettext 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => lightline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
      \ 'colorscheme': 'molokai',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'relativepath', 'modified'] ],
      \   'right': [ ['linter_checking', 'linter_errors', 'linter_warnings'],
      \              ['lineinfo'], ['percent'],
      \              ['fileformat', 'fileencoding', 'filetype'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"RO":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*FugitiveHead")?FugitiveHead():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*FugitiveHead") && ""!=FugitiveHead())'
      \ },
      \ 'component_expand': {
      \   'linter_checking': 'lightline#ale#checking',
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors': 'lightline#ale#errors'
      \ },
      \ 'component_type': {
      \   'linter_checking': 'right',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimroom
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-test
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>tt :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ts :TestSuite<CR>
nnoremap <silent> <leader>tr :TestLast<CR>
nnoremap <silent> <leader>tv :TestVisit<CR>
if has('terminal')
    let test#strategy = 'vimterminal'
    let test#vim#term_position = 'botright 15'
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ale (syntax checker and linter)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['flake8', 'pyright']
\}
let g:ale_linters_explicit = 1
let g:ale_python_auto_virtualenv = 1

" Pyright replaces jedi-vim's completion and code-navigation features while
" reusing ALE as the single editor integration layer.
let g:ale_completion_enabled = 1
let g:ale_completion_delay = 200

nmap <silent> <leader>a <Plug>(ale_next_wrap)

" Keep Vim's built-in gd and K behavior in non-Python buffers.
augroup python_lsp_mappings
    autocmd!
    autocmd FileType python nmap <buffer> <silent> gd <Plug>(ale_go_to_definition)
    autocmd FileType python nmap <buffer> <silent> gr <Plug>(ale_find_references)
    autocmd FileType python nmap <buffer> <silent> K <Plug>(ale_hover)
    autocmd FileType python nmap <buffer> <silent> <leader>rn <Plug>(ale_rename)
augroup END

" Disabling highlighting
let g:ale_set_highlights = 0

" Only run linting when saving the file
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_virtualtext_cursor = 'disabled'
let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Git gutter (Git diff)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_enabled=1
nnoremap <silent> <leader>d :GitGutterToggle<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => EditorConfig (project-specific EditorConfig rule)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:EditorConfig_exclude_patterns = ['fugitive://.*']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fugitive
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Copy the link to the line of a Git repository to the clipboard
nnoremap <leader>v :.GBrowse!<CR>
xnoremap <leader>v :GBrowse!<CR>
