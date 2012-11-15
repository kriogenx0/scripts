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

# OH MY ZSH
if [[ ! -d ~/.oh-my-zsh ]]; then
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

# Janus
if [[ ! -d ~/.vim || ! -d ~/.vim/janus ]]; then
  curl -Lo- https://bit.ly/janus-bootstrap | bash
fi

# Get git
brew install git

# Tig
if [[ ! -d /usr/local/bin/tig ]]; then
  brew install tig
fi

# VENDOR INSTALLS

if [[ ! -d ~/Sites/webconfig ]]; then
  mkdir ~/Sites/webconfig
fi

# Ruby Install
sh installs/vendors/install-theinstall.sh

# Get RVM to reload
if [[ -f ~/.rvmrc ]]; then
  echo 'rvm_auto_reload_flag=1' >> ~/.rvmrc
fi

# Uninstall Native Ruby
if [[ -d /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8 ]]; then
  sudo rm -r /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8
fi

# POW
# curl get.pow.cx | sh

# Nginx
# brew install nginx

# Xcode Select
if [[ -d "/Applications/Xcode.app/Contents" ]]; then
  sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
fi
