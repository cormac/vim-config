#!/bin/bash
echo -n "Do you want clojure support (y/N)"
read clojure

if [ $clojure == "y" ]; then
  git submodule add https://github.com/vim-scripts/VimClojure .vim/bundle/VimClojure
fi

git submodule init
git submodule update
if [ -f ~/.vimrc ]
then 
cp ~/.vimrc ~/.vimrc.bak
fi
cp -r ~/.vim ~/.vim.bak
rm -rf ~/.vim
cp -r .vim ~/.vim
cp .vimrc ~/.vimrc
rm -rf ~/.vim/bundle/**/.git
rm ~/.vim/bundle/**/.gitignore
cp -r snippets ~/.vim/bundle/snipmate/snippets
