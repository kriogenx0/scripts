#!/usr/bin/env bash

# TO USE THIS SCRIPT, RUN THIS IN TERMINAL
# curl https://raw.githubusercontent.com/kriogenx0/scripts/master/curl-me.sh | bash

kriogenx_dir=$HOME/.kriogenx

msg() {
  echo -e "\033[36m$1\033[0m"
}

if type git >/dev/null 2>&1; then
  # Kriogenx
  if [[ ! -d "$kriogenx_dir" ]]; then
    msg 'Installing Kriogenx Scripts...'
    git clone https://github.com/kriogenx0/scripts.git "$kriogenx_dir"
    msg "Kriogenx installed at $kriogenx_dir"

    # Run
    if [[ -e "$kriogenx_dir" ]]; then
      msg "Kriogenx is in!"
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
  fi
else
  msg 'Could not install kriogenx!'
  echo 'Git is required'
fi
