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
