#!/bin/sh

# RVM Install
if [[ ! -d ~/.rvm ]]; then
  curl -L https://get.rvm.io | bash -s stable --autolibs=3 --rails
fi

# Ruby Install
sh vendors/install-theinstall.sh

# Get RVM to reload
if [[ -f ~/.rvmrc ]]; then
  echo 'rvm_auto_reload_flag=1' >> ~/.rvmrc
fi

# Uninstall Native Ruby
if [[ -d /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems ]]; then
  sudo rm -r /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems
fi

# POW
# curl get.pow.cx | sh

# Nginx
if [[ ! `type nginx` =~ "not found" ]]; then
  brew install nginx
else
  brew upgrade nginx
fi

brew tap homebrew/dupes
brew install apple-gcc42

brew install automake
brew install libksba
brew install imagemagick
brew install readline

if [[ ! -e /usr/bin/gcc-4.2 && -e /usr/bin/gcc ]]; then
  sudo ln -s /usr/bin/gcc /usr/bin/gcc-4.2
fi
