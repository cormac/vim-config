"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pathogen inclusion 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call pathogen#infect()
call pathogen#helptags()

if has("autocmd")
  augroup module
    " Drupal *.module and *.install files.
    autocmd BufRead,BufNewFile *.module set filetype=php
    autocmd BufRead,BufNewFile *.install set filetype=php
    autocmd BufRead,BufNewFile *.inc set filetype=php
    autocmd BufRead,BufNewFile *.tpl set filetype=html
    autocmd BufRead,BufNewFile *.dust set filetype=html
    autocmd BufRead,BufNewFile *.wsgi set filetype=python
    autocmd BufRead,BufNewFile *.json set filetype=javascript
    autocmd BufRead,BufNewFile *.hbs set filetype=html
    autocmd BufNewFile,BufRead *.ccss set filetype=sass
  augroup END
endif

syntax on
let mapleader=","
set expandtab " tabs become spaces
set tabstop=2 " width of tabs
set shiftwidth=2
set autoindent " auto indentation
set smartindent

set fdm=syntax

set hlsearch "highlight search terms
set incsearch " highlight and search to while typing

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

set showmatch "Show matching bracets when text indicator is over them
set ruler " show current position
set nocompatible

nnoremap <leader>ev :vsplit $MYVIMRC<cr> " map ,ev to oedit my vimrc file

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set nu "show line numbers

set nobackup " don't create backup files or swap files - they annoy my version control
set nowb 
set noswapfile 

set hid " change buffer without save

map <C-B> :NERDTreeToggle<cr> " open nerdtree file browser
let NERDTreeIgnore = ['\.pyc$']


" Use the arrows to switch buffers
map <right> :bn<cr>
map <left> :bp<cr>

" alt left right for buffer switching
nnoremap <A-Left> :tabprevious<CR>
nnoremap <A-Right> :tabnext<CR>
filetype plugin on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>z <C-Y>,

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType scss set omnifunc=csscomplete#CompleteCSS
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType python set omnifunc=pythoncomplete#Complete " no worky neither
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Auto complete drupal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set dict +=~/.vim/dictionaries/drupal6.dict

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parentheses
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:hi MatchParen cterm=bold ctermbg=none ctermfg=none "embolden matching parentheses

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" from https://github.com/spf13/spf13-vim/blob/master/.vimrc
if has('statusline')
  set laststatus=2
  " Broken down into easily includeable segments
  set statusline=%<%f\    " Filename
  set statusline+=%w%h%m%r " Options
  set statusline+=\ [%{&ff}/%Y]            " filetype
  set statusline+=%#warningmsg#
  set statusline+=%{fugitive#statusline()}
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
  let g:syntastic_enable_signs=1
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Stuff that no work
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When vimrc is edited, reload it - doesn't seem to work always
autocmd! bufwritepost .vimrc source ~/.vimrc

set pastetoggle=<F2>

iabbrev adn and
iabbrev tehn then
iabbrev waht what

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => macvim colors
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256
:colorscheme koehler

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => json formatting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>j :%!python -m json.tool<CR>

