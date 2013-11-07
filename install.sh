#!/bin/sh

while true; do
    read -p "Install developer essentials? y/n " yn
    case $yn in
        [Yy]* ) sh packages/developer-essentials.sh; break;;
        [Nn]* ) break;;
        * ) echo "Please answer [y]es or [n]o.";;
    esac
done

while true; do
    read -p "Install ruby tools? y/n " yn
    case $yn in
        [Yy]* ) sh packages/ruby-install.sh; break;;
        [Nn]* ) break;;
        * ) echo "Please answer [y]es or [n]o.";;
    esac
done

while true; do
    read -p "Pimp My Shell? y/n " yn
    case $yn in
        [Yy]* ) sh packages/pimp-my-shell.sh; break;;
        [Nn]* ) break;;
        * ) echo "Please answer [y]es or [n]o.";;
    esac
done

while true; do
    read -p "Use git settings? y/n " yn
    case $yn in
        [Yy]* ) sh packages/git-settings.sh; break;;
        [Nn]* ) break;;
        * ) echo "Please answer [y]es or [n]o.";;
    esac
done

echo 'Done with packages'
