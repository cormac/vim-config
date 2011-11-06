if has("autocmd")
  " Drupal *.module and *.install files.
  augroup module
    autocmd BufRead,BufNewFile *.module set filetype=php
    autocmd BufRead,BufNewFile *.install set filetype=php
    autocmd BufRead,BufNewFile *.test set filetype=php
  augroup END
endif
syntax on


set expandtab " tabs become spaces
set tabstop=2 " width of tabs
set shiftwidth=2
set autoindent " auto indentation
set smartindent

set hlsearch "highlight search terms
set incsearch " highlight and search to while typing

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

set showmatch "Show matching bracets when text indicator is over them
set ruler " show current position
set nocompatible

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set nu "show line numbers

set nobackup " don't create backup files or swap files - they annoy my version control
set nowb 
set noswapfile 

set hid " change buffer without save

map <C-B> :NERDTreeToggle<cr> " open nerdtree file browser

" Use the arrows to something useful changed to use Ctrl arrow, arrows were
" pissing me off
map <C-right> :bn<cr>
map <C-left> :bp<cr>

filetype plugin on

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
set dict +=~/.vim/dictionaries/drupal6.dict

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parentheses
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:hi MatchParen cterm=bold ctermbg=none ctermfg=none "embolden matching parentheses


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Stuff that no work
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When vimrc is edited, reload it - doesn't seem to work always
autocmd! bufwritepost .vimrc source ~/.vimrc

map! <C-q> <C-xk> " supposed to map autocomplete to Ctrl - Space
:inoremap <C-x><C-o> <C-q>

nmap <F4> :w<CR>:make<CR>:cw<CR>


