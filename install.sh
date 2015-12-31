#!/usr/bin/env bash

[[ -n $kriogenx_dir ]] || kriogenx_dir=$HOME/Sites/kriogenx/scripts

k_install() {
  package=$1

  if [[ -e "$kriogenx_dir" ]]; then
    bash "$kriogenx_dir"/bin/$package
  else
    curl -fLsS https://raw.githubusercontent.com/kriogenx0/scripts/master/bin/$package | bash
  fi
}

read -p "Developer Essentials? y|n " yn
case $yn in
  Y|y|yes )
    k_install developer-setup
    ;;
  N|n|no )
    ;;
  * ) echo "Please answer [y]es or [n]o.";;
esac

if [[ ! -e "$kriogenx_dir" ]]; then
  read -p "Kriogenx Scripts? y|n " yn
  case $yn in
    Y|y|yes )
      k_install kriogenx-install
      ;;
    N|n|no )
      ;;
    * ) echo "Please answer [y]es or [n]o.";;
  esac
fi

read -p "Pimp My Shell? y|n " yn
case $yn in
  Y|y|yes )
    k_install pimp-my-shell
    ;;
  N|n|no )
    ;;
  * ) echo "Please answer [y]es or [n]o.";;
esac

read -p "Ruby Setup? y|n " yn
case $yn in
  Y|y|yes )
    k_install ruby-setup
    ;;
  N|n|no )
    ;;
  * ) echo "Please answer [y]es or [n]o.";;
esac

read -p "Pimp My Git? y|n " yn
case $yn in
  Y|y|yes )
    k_install git-defaults
    ;;
  N|n|no )
    ;;
  * ) echo "Please answer [y]es or [n]o.";;
esac

read -p "Run Mac OS X Hacks? y|n " yn
case $yn in
  Y|y|yes )
    k_install macos-defaults
    ;;
  N|n|no )
    ;;
  * ) echo "Please answer [y]es or [n]o.";;
esac

if [[ -e /Applications/Dropbox.app ]]; then
  read -p "Sync Applications with Dropbox? y|n " yn
  case $yn in
    Y|y|yes )
      k_install dropbox-takeover
      ;;
    N|n|no )
      ;;
    * ) echo "Please answer [y]es or [n]o.";;
  esac
fi

echo 'Kriogenx Packager Done!'

