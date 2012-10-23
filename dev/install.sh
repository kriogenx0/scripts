#!/usr/bin/env sh

# Brew
sudo chown -R `whoami` /usr/local
if [[ -e /usr/local/bin/brew ]]; then
  brew update
else
  ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
  brew doctor
fi

# Apple GCC
brew tap homebrew/dupes
brew install apple-gcc42

# GCC FIX FOR GEM BUILDING
if [[ ! -e /usr/bin/g++ && -e /usr/bin/llvm-g++-4.2 ]]; then
  ln -s /usr/bin/llvm-g++-4.2 /usr/bin/g++
fi

if [[ ! -e /usr/bin/gcc && -e /usr/bin/llvm-gcc-4.2 ]]; then
  ln -s /usr/bin/llvm-gcc-4.2 /usr/bin/gcc
fi

# OH MY ZSH
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

# Janus
#curl -Lo- https://bit.ly/janus-bootstrap | bash

# Ruby Install
sh install-theinstall.sh

# Uninstall Native Ruby
sudo rm -r /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8

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
if [[ -d "/Applications/Xcode.app/Contents" ]]; then
  sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
fi
