# shellcheck shell=bash
# Kriogenx aliases: system

# Remove Garbage Files
cleandir() {
  #find . -name '.svn' -type d -print0 | xargs -0 -t rm -rf
  find . -name '_notes' -type d -print0 | xargs -0 -t rm -rf
  find . -name '_vti_cnf' -type d -print0 | xargs -0 -t rm -rf
  find . -name '.DS_Store' -print0 | xargs -0 -t rm -rf
  find . -name '.BridgeCache' -print0 | xargs -0 -t rm -rf
  find . -name '.BridgeCacheT' -print0 | xargs -0 -t rm -rf
  find . -name 'Thumbs.db' -print0 | xargs -0 -t rm -rf
}

# GetSpace
getspace() {
  brew cleanup
  [[ -e ~/Library/Caches/Adobe/"Bridge CS6"/Cache ]] && sudo rm -rf ~/Library/Caches/Adobe/"Bridge CS6"/Cache/*
  [[ -e ~/Library/Caches/com.spotify.client/Storage ]] && sudo rm -rf ~/Library/Caches/com.spotify.client/Storage
  [[ -e ~/Library/Caches/Google/Chrome ]] && sudo rm -rf ~/Library/Caches/Google/Chrome
}

# Directories
alias pwdc='pwd | pbcopy'

# go up directories looking for a marker file named $1
dirup() {
  local marker="$1" dir i
  dir=$(pwd)
  i=0
  while [ "/" != "$dir" ] && [ "$i" -ne 16 ]; do
    if [ -f "$dir/$marker" ]; then
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
    i=$((i + 1))
  done
  return 1
}

# SET LAST DIR
lastdir()
{
  rm -f ~/.lastdir
  pwd > ~/.lastdir
}
# CD LAST DIR
cdl() {
  [[ -e ~/.lastdir ]] && cd "$(cat ~/.lastdir)" || return
}

# Services
services() {
  kextstat -kl | awk '!/com\.apple/{printf "%s %s\n", $6, $7}'
  sudo launchctl list | sed 1d | awk '!/0x|com\.(apple|openssh|vix\.cron)|org\.(amav|apac|cups|isc|ntp|postf|x)/{print $3}'; echo; sudo launchctl getenv DYLD_INSERT_LIBRARIES; echo; sudo defaults read com.apple.loginwindow LoginHook; echo; sudo crontab -l
  launchctl list | sed 1d | awk '!/0x|com\.apple|org\.(x|openbsd)/{print $3}'; echo; launchctl getenv DYLD_INSERT_LIBRARIES; echo; crontab -l
  ls -A /e*/{cr,la,mach}* {,/}Lib*/{Ad,Compon,Ex,Fram,In,Keyb,La,Mail/Bu,P*P,Priv,Qu,Scripti,Servi,Spo,Sta}* L*/Fonts .la*
  osascript -e 'tell application "System Events" to get name of login items'
}
