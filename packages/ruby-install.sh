#!/bin/sh

# RVM Install
if [[ ! -d ~/.rvm ]]; then
  curl -L https://get.rvm.io | bash -s stable --autolibs=3
fi

# OS X Named Streams Issue
echo "[default]" > $HOME/Library/Preferences/nsmb.conf # /etc/nsmb.conf
echo "streams=no" >> $HOME/Library/Preferences/nsmb.conf # | sudo tee -a /etc/nsmb.conf

# Get RVM to reload
if [[ -f ~/.rvmrc ]]; then
  echo 'rvm_auto_reload_flag=1' >> ~/.rvmrc
fi

# Uninstall Native Ruby
if [[ -d /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems ]]; then
  sudo rm -r /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems
fi

echo "Removing system gems"
sudo gem update --system > /dev/null
sudo gem clean > /dev/null

# POW
# curl get.pow.cx | sh

# Some dependencies
brew tap homebrew/dupes
brew install apple-gcc42

brew install wget proctools ack ctags-exuberant markdown
brew install automake
brew install libksba
brew install imagemagick
brew install readline

# Nginx
if [[ ! `type nginx` =~ "not found" ]]; then
  brew install nginx
else
  brew upgrade nginx
fi

