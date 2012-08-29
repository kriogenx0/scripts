#KRIO_USER="$(whoami)"
if [[ ! -d ~/Sites ]]; then
  mkdir ~/Sites
fi
if [[ ! -d ~/Sites/kriogenx ]]; then
  mkdir ~/Sites/kriogenx
fi
if [[ ! -d ~/Sites/kriogenx/scripts ]]; then
  git clone git@github.com:kriogenx0/scripts.git ~/Sites/kriogenx/scripts
fi

