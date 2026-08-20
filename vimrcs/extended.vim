"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important: 
"       This requires that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GUI related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set font according to system
if has("mac") || has("macunix")
    set gfn=IBM\ Plex\ Mono:h14,Hack:h14,Source\ Code\ Pro:h15,Menlo:h15
elseif has("win16") || has("win32")
    set gfn=IBM\ Plex\ Mono:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("gui_gtk2")
    set gfn=IBM\ Plex\ Mono\ 14,:Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("linux")
    set gfn=IBM\ Plex\ Mono\ 14,:Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("unix")
    set gfn=Monospace\ 11
endif

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" The personal config selects the final colorscheme after plugins are on the
" runtime path, avoiding multiple theme reloads during startup.
set background=dark


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fast editing and reloading of vimrc configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>e :edit ~/.vim_runtime/my_configs.vim<cr>
augroup reload_my_configs
    autocmd!
    autocmd BufWritePost ~/.vim_runtime/my_configs.vim source ~/.vim_runtime/my_configs.vim | redraw | echo 'Vim config reloaded'
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on 
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    call mkdir(expand('~/.vim_runtime/temp_dirs/undodir'), 'p')
    set undodir=~/.vim_runtime/temp_dirs/undodir//
    set undofile
catch
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart mappings on the command line
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
" it deletes everything until the last slash 
cno $q <C-\>eDeleteTillSlash()<cr>

" Bash like keys for the command line
cnoremap <C-A>		<Home>
cnoremap <C-E>		<End>
cnoremap <C-K>		<C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Map ½ to something useful
map ½ $
cmap ½ $
imap ½ $


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a`<esc>`<i`<esc>

" Map auto complete of (, ", ', [
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <C-r>=strftime("%d/%m/%y %H:%M:%S")<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType css set omnifunc=csscomplete#CompleteCSS


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Search and quickfix helpers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Grepper writes results to quickfix; unimpaired provides [q and ]q navigation.
nnoremap <silent> <leader>cc :botright copen<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif   

    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . escape(expand("%:p:h"), " ") . "/"
endfunc

" Run the current C, C++, Java, shell, Python, Go, Matlab, or HTML file with
" F5.  Paths are shell-escaped so projects containing spaces work correctly.

nnoremap <F5> :call CompileRun()<CR>
inoremap <F5> <Esc>:call CompileRun()<CR>
xnoremap <F5> <Esc>:call CompileRun()<CR>

function! CompileRun() abort
    let l:path = expand('%:p')
    if empty(l:path)
        echoerr 'Save the buffer before running it'
        return
    endif

    update
    let l:file = shellescape(l:path)
    let l:output = shellescape(fnamemodify(l:path, ':r'))

    if &filetype ==# 'c'
        execute '!cc ' . l:file . ' -o ' . l:output . ' && ' . l:output
    elseif &filetype ==# 'cpp'
        execute '!c++ ' . l:file . ' -o ' . l:output . ' && ' . l:output
    elseif &filetype ==# 'java'
        let l:dir = shellescape(fnamemodify(l:path, ':h'))
        let l:class = shellescape(fnamemodify(l:path, ':t:r'))
        execute '!cd ' . l:dir . ' && javac ' . l:file . ' && java ' . l:class
    elseif &filetype ==# 'sh'
        execute '!bash ' . l:file
    elseif &filetype ==# 'python'
        execute '!python3 ' . l:file
    elseif &filetype ==# 'go'
        execute '!go run ' . l:file
    elseif &filetype ==# 'matlab'
        execute '!octave ' . l:file
    elseif &filetype ==# 'html'
        if has('macunix') && executable('open')
            execute 'silent !open ' . l:file
        elseif executable('xdg-open')
            execute 'silent !xdg-open ' . l:file . ' >/dev/null 2>&1 &'
        else
            echoerr 'No supported browser opener found'
        endif
    else
        echohl WarningMsg
        echo 'No F5 runner configured for filetype: ' . &filetype
        echohl None
    endif
endfunction
