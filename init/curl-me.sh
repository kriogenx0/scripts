#!/bin/sh

# TO USE THIS SCRIPT, RUN THIS IN TERMINAL
# curl https://raw.github.com/kriogenx0/scripts/master/init/curl-me.sh | sh

mkdir -p ~/Sites
mkdir -p ~/Sites/kriogenx

# Install Homebrew
if [[ -z `which brew` ]]; then
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

# Git
if [[ -z `which git` ]]; then
  brew install git
fi

# Kriogenx
if [[ ! -d ~/Sites/kriogenx/scripts ]]; then
  git clone git://github.com/kriogenx0/scripts.git ~/Sites/kriogenx/scripts
else
  cd ~/Sites/kriogenx/scripts
  git pull --rebase
fi

