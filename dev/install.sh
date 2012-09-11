#!/usr/bin/env sh

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