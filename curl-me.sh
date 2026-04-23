#!/usr/bin/env bash

# TO USE THIS SCRIPT, RUN THIS IN TERMINAL
# curl https://raw.githubusercontent.com/kriogenx0/scripts/master/curl-me.sh | bash

kriogenx_dir=$HOME/.kriogenx

msg() {
  printf "\033[33m$1\033[0m\n"
}

msg "Kriogenx"
echo "Kriogenx is a set of dotfile tools to make the macOS terminal experience much better"

read -r -p "Download Kriogenx [y|n] " confirm
[[ "$confirm" =~ ^[Yy] ]] || exit 0

if type git >/dev/null 2>&1; then
  # Kriogenx
  if [[ ! -d "$kriogenx_dir" ]]; then
    msg 'Downloading Kriogenx Scripts...'
    # Xcode issues may happen here when using git
    git clone https://github.com/kriogenx0/scripts.git "$kriogenx_dir"

    # Run
    if [[ -e "$kriogenx_dir" ]]; then
      msg "Kriogenx downloaded to $kriogenx_dir"
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
    echo "This adds aliases, commands, and other fun things."
    export PATH=$PATH:"$kriogenx_dir"/bin
    source "$kriogenx_dir"/bin/profile-scripts
    source ~/.profile
  fi
else
  msg 'Git not found.'
  read -r -p "Download Kriogenx from GitHub as a zip? [y/N] " confirm
  [[ "$confirm" =~ ^[Yy] ]] || exit 0
  zip_url="https://github.com/kriogenx0/scripts/archive/refs/heads/master.zip"
  tmp_zip="$(mktemp).zip"

  if type curl >/dev/null 2>&1; then
    curl -fsSL "$zip_url" -o "$tmp_zip"
  elif type wget >/dev/null 2>&1; then
    wget -q "$zip_url" -O "$tmp_zip"
  else
    msg 'Could not install kriogenx!'
    echo 'Git, curl, or wget is required'
    exit 1
  fi

  if [[ ! -d "$kriogenx_dir" ]]; then
    unzip -q "$tmp_zip" -d "$HOME"
    mv "$HOME/scripts-master" "$kriogenx_dir"
  fi
  rm -f "$tmp_zip"

  if [[ -e "$kriogenx_dir" ]]; then
    msg "Kriogenx downloaded to $kriogenx_dir"
    msg "To get started, run kriogenx install:"
    msg "bash $kriogenx_dir/install.sh"
    msg "Installing ~/.profile"
    echo "This adds aliases, commands, and other fun things."
    export PATH=$PATH:"$kriogenx_dir"/bin
    source "$kriogenx_dir"/bin/profile-scripts
    source ~/.profile
  else
    msg 'Could not install kriogenx!'
  fi
fi
