#!/usr/bin/env bash
set -euo pipefail

# Kriogenx package installer: asks about each package and runs it.
# Needs a kriogenx checkout; get one first with:
#   curl https://raw.githubusercontent.com/kriogenx0/scripts/master/curl-me.sh | bash

KRIO_DIR="${KRIO_DIR:-${kriogenx_dir:-$HOME/.kriogenx}}"
KRIO="$KRIO_DIR/bin/kriogenx"

if [[ ! -x $KRIO ]]; then
  echo "Kriogenx not found in $KRIO_DIR. Install it first:" >&2
  echo "  curl https://raw.githubusercontent.com/kriogenx0/scripts/master/curl-me.sh | bash" >&2
  exit 1
fi

# k_install "<question>" <kriogenx args...>
k_install() {
  local message="$1" yn
  shift
  while true; do
    read -rp "$message [y|n] " yn
    case $yn in
      Y|y|yes) "$KRIO" "$@"; break ;;
      N|n|no) break ;;
      *) echo "Please answer [y]es or [n]o." ;;
    esac
  done
}

k_install "Developer Essentials (xcode, brew, git, tig, docker, ssh)" install essentials
k_install "Pimp My Shell" pimp-my-shell
k_install "Pimp My Git" pimp-my-git
k_install "Languages (ruby, node, python, rust, go via mise)" install languages
k_install "macOS Hacks" macos-hacks

echo 'Kriogenx Packager Done!'
