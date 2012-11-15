#!/usr/bin/env sh

if [[ -d ~/Sites/webconfig/hashrocket ]]; then
  echo "You've got Hashrocket Dotmatrix already"
  exit 0
fi

# https://github.com/hashrocket/dotmatrix
git clone git@github.com:hashrocket/dotmatrix.git ~/Sites/webconfig/hashrocket
cd ~/Sites/webconfig/hashrocket/dotmatrix
