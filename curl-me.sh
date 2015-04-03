#!/usr/bin/env bash

# TO USE THIS SCRIPT, RUN THIS IN TERMINAL
# curl https://raw.githubusercontent.com/kriogenx0/scripts/master/curl-me.sh | bash

kriogenx_dir=$HOME/Sites/kriogenx

msg() {
  echo -e "\033[36m$1\033[0m"
}

# Mac OS X
if [[ `sw_vers` =~ 'Mac OS X' ]]; then

  # Install Homebrew
  if type brew >/dev/null 2>&1; then
    msg 'Updating Homebrew...'
    brew update
  else
    msg 'Installing Homebrew...'
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  msg 'Brew Doctor...'
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
    msg 'Kriogenx added to ~/Sites/kriogenx/sites'
  else
    msg 'Updating kriogenx...'
    cd "$kriogenx_dir"/scripts
    git pull --rebase
  fi

  # Run
  if [[ -e "$kriogenx_dir" ]]; then
    msg "Kriogenx is in!"
    msg "To get started, run kriogenx install:"
    msg "$kriogenx_dir"
    #bash "$kriogenx_dir"/scripts/install.sh
  fi
else
  msg 'Could not install kriogenx!'
  echo 'Git not found'
fi
