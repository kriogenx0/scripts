#!/bin/sh

[[ -n $kriogenx_dir ]] || kriogenx_dir=$HOME/Sites/kriogenx/scripts

package_install() {
  package=$1

  if [[ -e "$kriogenx_dir" ]]; then
    sh "$kriogenx_dir"/packages/$package
  else
    $(curl -fLsS https://raw.githubusercontent.com/kriogenx0/scripts/master/packages/$package)
  fi
}

read -p "Install developer essentials? y/n " yn
case $yn in
  Y|y|yes )
    package_install developer-essentials.sh
    break;;
  N|n|no ) break;;
  * ) echo "Please answer [y]es or [n]o.";;
esac

if [[ ! -e "$kriogenx_dir" ]]; then
  read -p "Install Kriogenx Scripts? y/n " yn
  case $yn in
    Y|y|yes )
      package_install kriogenx-install.sh
      break;;
    N|n|no ) break;;
    * ) echo "Please answer [y]es or [n]o.";;
  esac
fi

read -p "Pimp My Shell? y/n " yn
case $yn in
  Y|y|yes )
    package_install pimp-my-shell.sh
    break;;
  N|n|no ) break;;
  * ) echo "Please answer [y]es or [n]o.";;
esac

read -p "Install Ruby tools? y/n " yn
case $yn in
  Y|y|yes )
     package_install ruby-install.sh
     break;;
  N|n|no ) break;;
  * ) echo "Please answer [y]es or [n]o.";;
esac

read -p "Pimp My Git? y/n " yn
case $yn in
  Y|y|yes )
    package_install git-settings.sh
    break;;
  N|n|no ) break;;
  * ) echo "Please answer [y]es or [n]o.";;
esac

read -p "Run Mac OS X Hacks? y/n " yn
case $yn in
  Y|y|yes )
    package_install macos.sh
    break;;
  N|n|no ) break;;
  * ) echo "Please answer [y]es or [n]o.";;
esac

if [[ -e /Applications/Dropbox.app ]]; then
  read -p "Sync Applications with Dropbox? y/n " yn
  case $yn in
    Y|y|yes )
      package_install dropbox-takeover.sh
      break;;
    N|n|no ) break;;
    * ) echo "Please answer [y]es or [n]o.";;
  esac
fi

echo 'Done!'
