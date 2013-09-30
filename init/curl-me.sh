#!/bin/sh

# TO USE THIS SCRIPT, RUN THIS IN TERMINAL
# curl https://raw.github.com/kriogenx0/scripts/master/init/curl-me.sh | sh

#KRIO_USER="$(whoami)"
if [[ ! -d ~/Sites ]]; then
  mkdir ~/Sites
fi
if [[ ! -d ~/Sites/kriogenx ]]; then
  mkdir ~/Sites/kriogenx
fi
if [[ `type git` =~ 'not found' ]]; then
  echo "Git is needed to get started"
fi
if [[ ! -d ~/Sites/kriogenx/scripts ]]; then
  git clone git://github.com/kriogenx0/scripts.git ~/Sites/kriogenx/scripts
fi

