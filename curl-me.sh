#!/usr/bin/env bash

# TO USE THIS SCRIPT, RUN THIS IN TERMINAL
# curl https://raw.githubusercontent.com/kriogenx0/scripts/master/curl-me.sh | sh

kriogenx_dir=$HOME/Sites/kriogenx

msg() {
  echo -e "\033[36m$1\033[0m"
}

# Mac OS X
if [[ `sw_vers` =~ 'Mac OS X' ]]; then

  # Install Homebrew
  if type brew >/dev/null 2>&1; then
    brew update
  else
    msg 'Installing Homebrew...'
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  brew doctor

  # Git
  if [[ ! `which git` =~ 'usr/local' ]]; then
    msg 'Installing Git...'
    brew install git
  fi

# Linux
else
  # Git
  sudo apt-get install git -yf
  # Curl
  sudo apt-get install curl -yf
fi

if type git >/dev/null 2>&1; then
  # Kriogenx
  if [[ ! -d "$kriogenx_dir"/scripts ]]; then
    msg 'Installing Kriogenx Scripts...'
    mkdir -p "$kriogenx_dir"
    git clone git://github.com/kriogenx0/scripts.git "$kriogenx_dir"/scripts
  else
    cd "$kriogenx_dir"/scripts
    git pull --rebase
  fi

  # Run
  [[ -e "$kriogenx_dir" ]] && bash "$kriogenx_dir"/scripts/install.sh
else
  echo 'Git not found'
fi
