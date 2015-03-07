#!/usr/bin/env sh

if [[ ! `type git` =~ 'not found' ]]; then
  mkdir -p ~/Sites/kriogenx
  if [[ ! -d ~/Sites/kriogenx/scripts ]]; then
    echo 'Installing Kriogenx Scripts...'
    git clone git://github.com/kriogenx0/scripts.git ~/Sites/kriogenx/scripts
  else
    cd ~/Sites/kriogenx/scripts
    git pull --rebase
  fi
else
  echo 'Git not found'
fi
