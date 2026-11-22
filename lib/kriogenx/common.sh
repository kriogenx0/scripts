# shellcheck shell=bash
# kriogenx: shared helpers

_confirm() {
  local prompt="$1" yn
  read -rp "$prompt [y|n] " yn
  case $yn in
    Y|y|yes) return 0 ;;
    *) return 1 ;;
  esac
}

_psa() {
  if [[ -z $1 ]]; then
    ps aux
  else
    ps aux | grep "$1" | grep -v grep
  fi
}

_killps() {
  local procs
  procs=$(_psa "$1" | awk '{print $2}')
  # shellcheck disable=SC2086 # intentionally unquoted: splits multiple PIDs
  [[ -n $procs ]] && kill -9 $procs
}
