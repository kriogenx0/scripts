#!/usr/bin/env sh

# Brew
sudo chown -R `whoami` /usr/local
brew update

# Apple GCC
brew tap homebrew/dupes
brew install apple-gcc42

# OH MY ZSH
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

# Janus
#curl -Lo- https://bit.ly/janus-bootstrap | bash

# Ruby Install
sh install-theinstall.sh

# Move Hashrocket
sh move-hashrocket.sh

# Install Kriogenx
sh install-kriogenx.sh

# ZSH THEME
if [ -d '~/.oh-my-zsh/themes' ]; then
  $(cd ~/.oh-my-zsh/themes; ln -s ~/Sites/kriogenx/scripts/shells/kriogenx.zsh-theme)
fi

# POW
# curl get.pow.cx | sh

# Xcode Select
if [ -d "/Applications/Xcode.app/Contents" ]; then
  sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
fi

# GCC FIX FOR GEM BUILDING
if [[ ! -f /usr/bin/g++ && -f /usr/bin/llvm-g++-4.2 ]]; then
  ln -s /usr/bin/llvm-g++-4.2 /usr/bin/g++
fi

if [[ ! -f /usr/bin/gcc && -f /usr/bin/llvm-gcc-4.2 ]]; then
  ln -s /usr/bin/llvm-gcc-4.2 /usr/bin/gcc
fi
