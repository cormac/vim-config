Vim Configuration
=================

This is the vim configuration I am using day to day. Plugins include nerdtree and snipmate. I've created dictionaries for both drupal 6 and drupal 7 core functions too. You'll need to reference the one you want to use in the .vimrc. Currently it is pointed at the drupal6 file

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

Update
------
I've started using pathogen to manage plugins. Turns out it's awesome, so I've added it here. Thanks Tim Pope http://tpo.pe/


