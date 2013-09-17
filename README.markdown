Vim Configuration
=================

This is the vim configuration I am using day to day. Plugins can be seen in .vim/bundle directory.  
All plugins are stored as git submodules, and managed by pathogen, thanks, Tim Pope http://tpo.pe/

Installation
------------
If you want to install quickly run the install.sh file, but be warned, all it does is copy the .vimrc file to your home directory, so any old one will be overwritten. To be nice the old one will first be copied to '~/.vimrc.bak'. 

It also moves your old .vim folder to .vim.bak and writes my plugins into a new .vim - so there

Syntastic Requirements
----------------------

js - jslint or jshint  
npm install -g jshint  

python - pyflakes  
pip install pyflakes  
there is some work done on getting syntastic to play nice in virtualenv, but not quite there yet  

