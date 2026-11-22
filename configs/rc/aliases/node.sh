# shellcheck shell=bash
# Kriogenx aliases: node

# node
# show versions
nov() {
  npm show "$1@*" version
}
