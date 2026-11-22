# shellcheck shell=bash
# Kriogenx aliases: core

# Traversing
alias l='ls -lAh'
alias ll='ls -l'
alias la='ls -lAh'   #Show all, sort by extension
alias lll='ls -lAh'
alias lt="ls -R | grep \":$\" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
alias ltl="lt | less"

# Search Directory
lss() {
  if [[ -n $1 ]]; then
    la | grep "$1"
  else
    la
  fi
}

cl() {
  cd "$1" && ls -l
}
mkd() {
  mkdir -p "$1" && cd "$1" || return
}
alias ds='du -d 1 | sort -n'
si() {
  cd "$HOME/Sites/$1" || return
  [[ -z $1 ]] && ls -la
}

# Common Binaries
o() {
  local IFS='/'
  open "$*"
}
alias oo='open .'
ox() {
  if [[ -n "$1" ]]; then
    open "$1"/*.xcodeproj
  else
    local proj
    proj=$(find . -name "*.xcodeproj" -maxdepth 5 | head -1)
    [[ -n "$proj" ]] && open "$proj" || echo "No .xcodeproj found"
  fi
}
alias xc='open -a Xcode'
alias c='clear'
alias lns="ln -s"
alias bashcommands="bind -p | sed '/self.insert/d;/^#/d;/do-lowercase/d'"

# Editor
export IDE="code"
# export EDITOR=/usr/bin/vim
export EDITOR=$IDE
alias e=$IDE
alias ee='e .'
alias a='atom'
alias aa='a .'
alias v='vim'
alias vi='vim'
alias svi='sudo vim'
alias rmf='rm -rf'
alias tailf='tail -f'

# Move & Create Directory
mvd() {
  mkdir -p "$2"; mv "$1" "$2"
}
alias grepp='grep -irn --color=auto --exclude="*~"'
grepr() {
  grepp -e "$1" .
}
grp() {
  grepp --exclude="*.git" --exclude="*.meteor" "$1" .
}
# With Word boundaries
grpb() {
  grepp --exclude="*.git" --exclude="*.meteor" "\b$1\b" .
}
egrp() {
  grep -Ern "$1" .
}
fnd() {
  find . -name "*$1*"
}

# Print Path
alias ppath='echo $PATH | tr ':' "\n"'

# Processes
psa() {
  if [[ -z $1 ]]; then
    ps aux
  else
    ps aux | grep "$1" | grep -v grep
  fi
}
killps() {
  local procs
  procs=$(psa "$1" | awk '{print $2}')
  # shellcheck disable=SC2086 # intentionally unquoted: splits multiple PIDs
  [[ -n $procs ]] && kill -9 $procs
}

# tar compress
tarc() {
  local a="${1%.*}.tar.gz"
  /usr/bin/tar cvf "$a" "$1"
}

# ----------

# rsync
# TODO: convert to an array to fix quoting (shellcheck SC2089/SC2090); deferred
# since rnc/cps/mvs/cpmirror/drive_sync/two_way_sync all rely on its current
# word-splitting behavior and need to be updated together.
# shellcheck disable=SC2089
RSYNC_EXCLUDE='--exclude="..*" --exclude="._*" --exclude=".!*"'\
'--exclude=".dropbox*" --exclude ".DS_Store" --exclude=".Spotlight*"'\
'--exclude="Thumbs.db" --exclude ".BridgeCache*"'\
'--exclude="_no_sync" --exclude="_no_redundancy" --exclude="-no_redundancy"'\
"--exclude='.AppleDB' --exclude='.com.apple.timemachine.supported' --exclude='.dbfseventsd' --exclude='.DocumentRevisions*' --exclude='.fseventsd' --exclude='.TemporaryItems' --exclude='.Trash*' --exclude='.vol' --exclude='.VolumeIcon.icns'"

alias rnc="rsync -aEhuvz --progress --stats $RSYNC_EXCLUDE"
# copy sync
cps() {
  rnc "${1%.*}"/ "$2"
}
# move sync
mvs() {
  rnc --remove-source-files "${1%.*}"/ "$2"
}
# copy mirror
cpmirror() {
  rnc -aEhvz --delete "${1%.*}"/ "$2"
}
drive_sync() {
  if [[ ! -e "$1" ]]; then
    echo "$1 not found"
    exit
  fi
  if [[ ! -e "$2" ]]; then
    echo "$2 not found"
    exit
  fi
  echo "Syncing from $1 to $2"
  # shellcheck disable=SC2086,SC2090 # see RSYNC_EXCLUDE TODO above
  rsync -aEhuv --progress --stats --partial-dir="._rsync-partial" --delete $RSYNC_EXCLUDE "${1%.*}"/ "$2"
}
two_way_sync() {
  rnc "${1%.*}"/ "$2"
  rnc "${2%.*}"/ "$1"
}

# Warning: Deletes directories with invisible files
delete_empty_dirs() {
  find "$1"/ -type d -empty -delete
}

# ----------

# Web Server
alias ports='netstat -lan'
alias portslisten="ports | egrep 'Proto|LISTEN'"
webports() {
  ps auxwww | grep LISTEN
  portslisten
  lsof -wni tcp
}
alias wsports='webports'
alias tcpports='lsof -wi tcp'

# portinfo 6377
portinfo() {
  lsof -wi ":$1"
}
