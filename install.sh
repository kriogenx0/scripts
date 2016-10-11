#!/usr/bin/env bash

[[ -n $kriogenx_dir ]] || kriogenx_dir=$HOME/.kriogenx

k_install_package() {
  package=$1

  if [[ -e "$kriogenx_dir" ]]; then
    bash "$kriogenx_dir"/bin/$package
  else
    curl -fLsS https://raw.githubusercontent.com/kriogenx0/scripts/master/bin/$package | bash
  fi
}

k_install() {
  package=$1
  message=$2

  read -p "$message [y|n] " yn
  case $yn in
    Y|y|yes )
      k_install $package
      ;;
    N|n|no )
      ;;
    * ) echo "Please answer [y]es or [n]o.";;
  esac
}

k_install developer-setup "Developer Essentials"
k_install pimp-my-shell "Pimp My Shell"
k_install git-defaults "Pimp My Git"
k_install ruby-setup "Install Ruby & RVM"
k_install macos-defaults "macOS Hacks"

if [[ -e /Applications/Dropbox.app ]]; then
  k_install dropbox-takeover "Dropbox Syncing Applications"
fi

echo 'Kriogenx Packager Done!'

