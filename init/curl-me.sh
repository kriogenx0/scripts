#!/bin/sh

# TO USE THIS SCRIPT, RUN THIS IN TERMINAL
# curl https://raw.github.com/kriogenx0/scripts/master/init/curl-me.sh | sh

# Mac OS X
if [[ `sw_vers` =~ 'Mac OS X' ]]; then

  # Install Homebrew
  if [[ -z `which brew` ]]; then
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
  fi

  # Git
  #iif [[ -z `which git` ]]; then
  brew install git
  #fi

# Linux
else
  # Git
  sudo apt-get install git -yf
  # Curl
  sudo apt-get install curl -yf
fi

# Kriogenx
if [[ ! `type git` =~ 'not found' ]]; then
  mkdir -p ~/Sites/kriogenx
  if [[ ! -d ~/Sites/kriogenx/scripts ]]; then
    git clone git://github.com/kriogenx0/scripts.git ~/Sites/kriogenx/scripts
  else
    cd ~/Sites/kriogenx/scripts
    git pull --rebase
  fi
else
  echo 'Git not found'
fi
