#!/usr/bin/env bash

# TO USE THIS SCRIPT, RUN THIS IN TERMINAL
# curl https://raw.githubusercontent.com/kriogenx0/scripts/master/curl-me.sh | bash

kriogenx_dir=$HOME/.kriogenx

msg() {
  printf "\033[36m$1\033[0m\n"
}

if type git >/dev/null 2>&1; then
  # Kriogenx
  if [[ ! -d "$kriogenx_dir" ]]; then
    msg 'Installing Kriogenx Scripts...'
    git clone https://github.com/kriogenx0/scripts.git "$kriogenx_dir"

    # Run
    if [[ -e "$kriogenx_dir" ]]; then
      msg "Kriogenx installed at $kriogenx_dir"
      msg "To get started, run kriogenx install:"
      msg "bash $kriogenx_dir"/install.sh
    fi
  else
    msg 'Kriogenx is already installed'
    cd "$kriogenx_dir"
    git pull --rebase
  fi

  if [[ -e "$kriogenx_dir" ]]; then
    msg "Installing ~/.profile"
    export PATH=$PATH:"$kriogenx_dir"/bin
    source "$kriogenx_dir"/bin/profile-scripts
    source ~/.profile
  fi
else
  msg 'Could not install kriogenx!'
  echo 'Git is required'
fi
