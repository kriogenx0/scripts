#!/bin/sh

while true; do
    read -p "Install kriogenx devtools? y/n " yn
    case $yn in
        [Yy]* ) sh installs/devtools-install.sh; break;;
        [Nn]* ) break;;
        * ) echo "Please answer [y]es or [n]o.";;
    esac
done

while true; do
    read -p "Hijack bashrc and zshrc, and make shellrc? y/n " yn
    case $yn in
        [Yy]* ) sh installs/shellrc-install.sh; break;;
        [Nn]* ) break;;
        * ) echo "Please answer [y]es or [n]o.";;
    esac
done

while true; do
    read -p "Use git settings? y/n " yn
    case $yn in
        [Yy]* ) sh installs/git-settings.sh; break;;
        [Nn]* ) break;;
        * ) echo "Please answer [y]es or [n]o.";;
    esac
done

echo 'Done with installs'
