if [ -f ~/.vimrc ]
then 
cp ~/.vimrc ~/.vimrc.bak
fi
cp -r ~/.vim ~/.vim.bak
rm -r ~/.vim
cp -r .vim ~/.vim
cp .vimrc ~/.vimrc
