# shellcheck shell=bash
# Kriogenx aliases: kriogenx

# Bash Aliases
alias brc="vi ~/.profile"
alias bashrc="brc"

# shellcheck disable=SC1090 # dynamic target, can't be statically resolved
_editrc() { vi "$1"; source "$1"; }

###########
# Kriogenx
alias krc='_editrc "$KRIOGENX_RC"'
# aliasrc <topic>: edit + reload one alias file; no topic lists them
aliasrc() {
  if [[ -z $1 ]]; then
    echo "Alias topics: $KRIOGENX_ALIAS_TOPICS"
    echo "Usage: aliasrc <topic>"
  elif [[ -f "$KRIOGENX_ALIASES_DIR/$1.sh" ]]; then
    _editrc "$KRIOGENX_ALIASES_DIR/$1.sh"
  else
    echo "aliasrc: no topic '$1' (topics: $KRIOGENX_ALIAS_TOPICS)" >&2
    return 1
  fi
}
alias arc='aliasrc'
alias urc='_editrc "$USER_RC"'
alias kds='cd "$KRIOGENX_DIR"'
alias kgig='cp "$KRIOGENX_DIR"/configs/git/gitignore ./.gitignore'
alias kk='kriogenx'
kup() {
  kriogenx update
}

whatsmyip() {
  curl ipinfo.io/ip
}

# Claude
alias claudedanger="claude --dangerously-skip-permissions"
