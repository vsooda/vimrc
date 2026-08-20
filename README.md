![VIM](https://dnp4pehkvoo6n.cloudfront.net/43c5af597bd5c1a64eb1829f011c208f/as/Ultimate%20Vimrc.svg)

# The Ultimate vimrc

Over the last 10 years, I have used and tweaked Vim. This configuration is the ultimate vimrc (or at least my version of it).

There are two versions:

* **The Basic**: If you want something small just copy [basic.vim](https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim) into your ~/.vimrc and you will have a good basic setup
* **The Awesome**: Includes a curated plugin set, one consistent theme, and additional configurations

I would, of course, recommend using the awesome version.


## How to install the Awesome version?
### Install for your own user only
The awesome version includes a focused set of plugins and configurations. To install it:

	git clone --depth=1 https://github.com/vsooda/vimrc.git ~/.vim_runtime
	sh ~/.vim_runtime/install_awesome_vimrc.sh
	
### Install for multiple users
To install for multiple users, the repository needs to be cloned to a location accessible for all the intended users.

	git clone --depth=1 https://github.com/vsooda/vimrc.git /opt/vim_runtime
	sh /opt/vim_runtime/install_awesome_parameterized.sh /opt/vim_runtime user0 user1 user2
	# to install for all users with home directories, note that root will not be included
	sh /opt/vim_runtime/install_awesome_parameterized.sh /opt/vim_runtime --all
	
Naturally, `/opt/vim_runtime` can be any directory, as long as all the users specified have read access.

## Fonts

I recommend using [IBM Plex Mono font](https://github.com/IBM/plex) (it's an open-source and awesome font that can make your code look beautiful). The Awesome vimrc is already setup to try to use it.

Some other fonts that Awesome will try to use:

* [Hack](http://sourcefoundry.org/hack/)
* [Source Code Pro](https://adobe-fonts.github.io/source-code-pro/)

## How to install the Basic version?

The basic version is just one file and no plugins. Just copy [basic.vim](https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim) and paste it into your vimrc.

The basic version is useful to install on remote servers where you don't need many plugins, and you don't do many edits.

	git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
	sh ~/.vim_runtime/install_basic_vimrc.sh


## How to install on Windows?

Use [gitforwindows](http://gitforwindows.org/) to checkout the repository and run the installation instructions above. No special instructions needed ;-)


## How to install on Linux

If you have vim aliased as `vi` instead of `vim`, make sure to either alias it: `alias vi=vim`. Otherwise, `apt-get install vim`


## How to update to latest version?

    cd ~/.vim_runtime
    git pull --rebase
    python3 update_plugins.py

Pass plugin names to update only a subset, for example:

    python3 update_plugins.py vim-grepper vim-sleuth

## Some screenshots

Colors when editing a Python file:

![Screenshot 1](https://dnp4pehkvoo6n.cloudfront.net/07583008e4da885801657e8781777844/as/Python%20editing.png)

[NERD Tree](https://github.com/preservim/nerdtree) plugin in a terminal window:
![Screenshot 3](https://dnp4pehkvoo6n.cloudfront.net/ae719203166585d64728f28398f4b1b7/as/Terminal%20usage.png)

Distraction free mode using [goyo.vim](https://github.com/junegunn/goyo.vim):
![Screenshot 4](https://dnp4pehkvoo6n.cloudfront.net/f0dcc4c9739148c56cbf8285a910ac41/as/Zen%20mode.png)


## Included Plugins

The bundle intentionally stays compact. User-facing plugins include:

* [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim): fuzzy file, buffer, and MRU finder
* [NERDTree](https://github.com/preservim/nerdtree): project tree explorer
* [vim-grepper](https://github.com/mhinz/vim-grepper): asynchronous ripgrep search into quickfix
* [ALE](https://github.com/dense-analysis/ale): diagnostics and lint integration
* [lightline.vim](https://github.com/itchyny/lightline.vim): statusline and tabline
* [copilot.vim](https://github.com/github/copilot.vim): GitHub Copilot completion
* [editorconfig-vim](https://github.com/editorconfig/editorconfig-vim) and [vim-sleuth](https://github.com/tpope/vim-sleuth): project and heuristic indentation settings
* [vim-fugitive](https://github.com/tpope/vim-fugitive), [vim-rhubarb](https://github.com/tpope/vim-rhubarb), and [vim-gitgutter](https://github.com/airblade/vim-gitgutter): Git workflow and change indicators
* [vim-visual-multi](https://github.com/mg979/vim-visual-multi): multiple selections and cursors
* [vim-unimpaired](https://github.com/tpope/vim-unimpaired): paired navigation and option toggles
* [vim-test](https://github.com/vim-test/vim-test): run the nearest test, current file, or full test suite
* [snipMate](https://github.com/garbas/vim-snipmate) and [vim-snippets](https://github.com/honza/vim-snippets): snippets
* [vim-commentary](https://github.com/tpope/vim-commentary), [vim-surround](https://github.com/tpope/vim-surround), [vim-repeat](https://github.com/tpope/vim-repeat), and [vim-abolish](https://github.com/tpope/vim-abolish): core editing operators
* [vim-expand-region](https://github.com/terryma/vim-expand-region), [vim-indent-object](https://github.com/michaeljsmith/vim-indent-object), [vim-yankstack](https://github.com/maxbrunsfeld/vim-yankstack), and [vim-lastplace](https://github.com/farmergreg/vim-lastplace): selection, text objects, yank history, and cursor restoration
* [goyo.vim](https://github.com/junegunn/goyo.vim) and [vim-markdown](https://github.com/plasticboy/vim-markdown): focused Markdown writing


## Included color schemes

The configuration ships one selected theme: [Molokai](https://github.com/tomasr/molokai).


Vim 9's built-in filetype support handles general languages; only Markdown
keeps a dedicated syntax plugin.


## Python development

ALE uses Flake8 for linting and Pyright for completion, type information, and
code navigation. Install both executables once:

    brew install flake8
    npm install --global pyright

Useful Python mappings:

* `gd`: go to definition; `gr`: find references
* `K`: show hover documentation; `<leader>rn`: rename a symbol
* `<leader>tt`: run the nearest test; `<leader>tf`: run the current test file
* `<leader>ts`: run the suite; `<leader>tr`: repeat the last test

Pytest itself remains a per-project dependency and should be installed in the
project's virtual environment. Use `:ALEInfo` to verify that Vim can find
`flake8` and `pyright-langserver`.

For projects that standardize on Ruff, ALE can use `ruff` and `ruff_format`
instead of Flake8. Do not enable both Flake8 and Ruff for the same rules, or
Vim will show duplicate diagnostics.


## How to include your own stuff?

After you have installed the setup,
create an empty `~/.vim_runtime/my_configs.vim` file for further customization.
This file's syntax matches `vimrc` syntax,
and add `vimrc` lines like `set number` as needed.

For instance, my `my_configs.vim` looks like this:

	~/.vim_runtime > cat my_configs.vim
	map <leader>ct :cd ~/Desktop/Todoist/todoist<cr>
	map <leader>cw :cd ~/Desktop/Wedoist/wedoist<cr> 

You can also install your plugins, for instance, via pathogen you can install [vim-rails](https://github.com/tpope/vim-rails):

	cd ~/.vim_runtime
	git clone git://github.com/tpope/vim-rails.git my_plugins/vim-rails

You can also install plugins without any plugin manager (vim 8+ required):

* Create pack plugin directory:\
`mkdir -p ~/.vim_runtime/pack/plugins/start`
* Clone the plugin that you want in that directory, for example:\
`git clone --depth=1 git://github.com/maxmellon/vim-jsx-pretty  ~/.vim_runtime/pack/plugins/start/vim-jsx-pretty`


## Key Mappings

The [leader](http://learnvimscriptthehardway.stevelosh.com/chapters/06.html#leader) is `,`, so whenever you see `<leader>` it means `,`.


### Normal mode mappings

Fast saving of a buffer (`<leader>w`):

```vim
nmap <leader>w :w!<cr>
```

Map `<Space>` to `/` (search) and `<Ctrl>+<Space>` to `?` (backwards search):
```vim	
map <space> /
map <C-space> ?
```
Disable highlights when you press `<leader><cr>`:

```vim
map <silent> <leader><cr> :noh<cr>
```
Smart way to move between windows (`<ctrl>j` etc.):
```vim	
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
```
Closing of the current buffer(s) (`<leader>bd` and (`<leader>ba`)):
```vim	
" Close current buffer
map <leader>bd :Bclose<cr>

" Close all buffers
map <leader>ba :1,1000 bd!<cr>
```	
Useful mappings for managing tabs:
```vim	
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=escape(expand("%:p:h"), " ")<cr>/
```	
Switch [CWD](http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file) to the directory of the open buffer:
```vim	
map <leader>cd :cd %:p:h<cr>:pwd<cr>
```	
Open vim-grepper's ripgrep prompt for fast project search:
```vim	
nnoremap <leader>g :Grepper -tool rg<CR>
```
Quickly open a buffer for scripbble:
```vim	
map <leader>q :e ~/buffer<cr>
```
Toggle paste mode on and off:
```vim	
map <leader>pp :setlocal paste!<cr>
```

### Visual mode mappings

Visual mode pressing `*` or `#` searches for the current selection:
```vim
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>
```
Search for the visual selection with vim-grepper:
```vim
xmap <leader>g <Plug>(GrepperOperator)
```
When you press `<leader>r` you can search and replace the selected text:
```vim
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>
```
Surround the visual selection in parenthesis/brackets/etc.:
```vim
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a`<esc>`<i`<esc>
```

### Insert mode mappings

Quickly insert parenthesis/brackets/etc.:
```vim
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i
inoremap $t <><esc>i
```
Insert the current date and time (useful for timestamps):
```vim
iab xdate <C-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
```

### Command line mappings

$q is super useful when browsing on the command line. It deletes everything until the last slash:
```vim
cno $q <C-\>eDeleteTillSlash()<cr>
```
Bash like keys for the command line:
```vim
cnoremap <C-A>		<Home>
cnoremap <C-E>		<End>
cnoremap <C-K>		<C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
```

Write the file as sudo (works only on Unix). Super useful when you open a file and you don't have permissions to save your changes. [Vim tip](http://vim.wikia.com/wiki/Su-write):

    :W 

### Plugin related mappings

* `<C-f>` or `<leader>j`: find files with CtrlP
* `<leader>f`: recently used files; `<leader>b`: open buffers
* `<leader>nn` or `<F9>`: toggle NERDTree; `<leader>nf`: reveal current file
* `<leader>g`: project search with ripgrep; in Visual mode search the selection
* `[q` / `]q`: previous/next quickfix result; `[l` / `]l`: location-list result
* `<C-s>`: add the word under the cursor to vim-visual-multi; `<M-s>`: select all
* `<C-p>` / `<C-n>` after a paste: older/newer yankstack entry
* Insert-mode `<C-j>` / `<C-k>`: next/previous snipMate placeholder
* `<leader>a`: next ALE diagnostic
* `<leader>z`: distraction-free Goyo mode
* `<leader>v`: copy the current GitHub line URL with Fugitive/Rhubarb

See `:help unimpaired`, `:help visual-multi`, and `:help grepper` for the
additional mappings provided by the new plugins.

### Spell checking
Pressing `<leader>ss` will toggle spell checking:
```vim
map <leader>ss :setlocal spell!<cr>
```
Shortcuts using `<leader>` instead of special characters:
```vim
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=
```
### Running Code
To run code directly from vim, press `F5`. The currently open code will execute without you having to type anything.

Can be used to execute code written in C, C++, Java, Python, Go, Octave, Bash scripts and HTML. To edit how you want your code to be executed, make changes in the file `~/.vim_runtime/vimrcs/extended.vim`

### Quickfix

Grepper and ALE put results in Vim's quickfix/location lists. Use
`<leader>cc` to open quickfix, `[q` / `]q` to navigate quickfix, and
`[l` / `]l` to navigate the current location list.

## How to uninstall
Just do following:
* Remove `~/.vim_runtime`
* Remove any lines that reference `.vim_runtime` in your `~/.vimrc`


## Looking for a remote-first job?

Maintaining this Vim configuration isn't my day job. Daily I am the founder/CEO of [Doist](https://doist.com/). You could come and help us build the workplace of the future while living a balanced life (anywhere in the world 🌍🌎🌏).

PS: Using Vim isn't a requirement 😄
