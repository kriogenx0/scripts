# shellcheck shell=bash
# Kriogenx aliases: apps

####################
# Apps

# TextEdit
edi() { open -e "$@"; }

# Browser
browser() {
  URL=$1
  python -mwebbrowser "$URL"
  [[ -x $BROWSER ]] && exec "$BROWSER" "$URL"
  path=$(which xdg-open || which gnome-open) && exec "$path" "$URL"
}

####################
# SSH
sshcopy() {
  if [[ -e ~/.ssh/id_rsa.pub ]]; then
    pbcopy < ~/.ssh/id_rsa.pub
    echo "Copied ssh key into clipboard"
  else
    echo "SSH key could not be found"
  fi
}
alias sshconfig="vi ~/.ssh/config"
alias sshadd="ssh-add --apple-load-keychain"

# Dropbox
alias dropboxpurge="rm -rf ~/Dropbox/.dropbox.cache; echo Dropbox cache deleted"

# Vagrant
alias vag='vagrant'
alias vagu='vagrant up'
alias vagup='vagrant up --provision'
alias vagp='vagrant provision'
alias vagd='vagrant destroy -f'
alias vagh='vagrant halt'
alias vags='vagrant ssh'
alias vagss='vagrant suspend'
