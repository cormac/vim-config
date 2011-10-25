if [ -f ~/.vimrc ]
then 
cp ~/.vimrc ~/.vimrc.bak
fi
cp -r .vim ~/.vim
cp .vimrc ~/.vimrc
