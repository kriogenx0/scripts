#!/usr/bin/env sh

# Brew
if [[ ! -d /usr/local ]]; then
  sudo mkdir /usr/local
fi
sudo chown -R `whoami` /usr/local
if [[ -e /usr/local/bin/brew ]]; then
  brew update
else
  ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
  brew doctor
fi

# Apple GCC
brew tap homebrew/dupes
if [[ ! -e /usr/local/bin/gcc-4.2 ]]; then
  brew install apple-gcc42
fi

# GCC FIX FOR GEM BUILDING
if [[ ! -e /usr/bin/g++ && -e /usr/bin/llvm-g++-4.2 ]]; then
  ln -s /usr/bin/llvm-g++-4.2 /usr/bin/g++
fi

if [[ ! -e /usr/bin/gcc && -e /usr/bin/llvm-gcc-4.2 ]]; then
  ln -s /usr/bin/llvm-gcc-4.2 /usr/bin/gcc
fi

# git
if [[ ! `type git` =~ "not found"]]; then
  brew install git
else
  brew upgrade git
fi

# OH MY ZSH
if [[ ! -d ~/.oh-my-zsh ]]; then
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

# Janus
if [[ ! `type ruby` =~ "not found"]]; then
  if [[ ! -d ~/.vim || ! -d ~/.vim/janus ]]; then
    curl -Lo- https://bit.ly/janus-bootstrap | bash
  elif [[ -d ~/.vim/janus ]]; then
    `cd ~/.vim/janus; git pull`
  fi
else
  echo 'Janus - Latest Ruby required to install Janus'
fi

# Tig
if [[ ! `type tig` =~ "not found"]]; then
  brew install tig
else
  brew upgrade tig
fi

########
# VENDOR INSTALLS

if [[ ! -d ~/Sites/webconfig ]]; then
  mkdir ~/Sites/webconfig
fi

# Xcode Select
if [[ -d "/Applications/Xcode.app/Contents" ]]; then
  sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
fi

# SSH
if [ ! -d ~/.ssh ]; then
  echo 'Looks like ssh is not set up'
  read -p "Enter your email address: " a
  if [[ -n $a ]]; then
    ssh-keygen -t rsa -C "$a"
    pbcopy < ~/.ssh/id_rsa.pub;
    echo "Created SSH key and copied public key to clipboard"
  fi
fi
