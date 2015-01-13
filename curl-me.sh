#!/bin/sh

# TO USE THIS SCRIPT, RUN THIS IN TERMINAL
# curl https://raw.githubusercontent.com/kriogenx0/scripts/master/init/curl-me.sh | sh

kriogenx_dir=$HOME/Sites/kriogenx

# Mac OS X
if [[ `sw_vers` =~ 'Mac OS X' ]]; then

  # Install Homebrew
  if [[ ! -d /usr/local ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    brew update
  fi
  brew doctor

  # Git
  if [[ ! `which git` =~ 'usr/local' ]]; then
    brew install git
  fi

# Linux
else
  # Git
  sudo apt-get install git -yf
  # Curl
  sudo apt-get install curl -yf
fi

if [[ ! `type git` =~ 'not found' ]]; then
  # Kriogenx
  mkdir -p "$kriogenx_dir"
  if [[ ! -d "$kriogenx_dir"/scripts ]]; then
    git clone git://github.com/kriogenx0/scripts.git "$kriogenx_dir"/scripts
  else
    cd "$kriogenx_dir"/scripts
    git pull --rebase
  fi

  # Run
  [[ -e "$kriogenx_dir" ]] && sh "$kriogenx_dir"/scripts/install.sh
else
  echo 'Git not found'
fi
