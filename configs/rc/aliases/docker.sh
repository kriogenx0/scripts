# shellcheck shell=bash
# Kriogenx aliases: docker

# Docker
: "${DOCKER_APP:=docker}"
alias dr='$DOCKER_APP'
alias dri='dr images'
alias drip='dr image prune'
alias dripa='dr image prune -a'
alias drr='dr run -t -p 4000:80'
alias drcl='dr container ls'
alias drc='dr container ls'
alias drcp='dr container prune'
alias drps='dr ps'
alias drv='dr volume ls'
alias dra='dr attach'
alias drl='dr logs'
alias drsp="dr system prune -af"
alias drb="dr build"

# Docker Shell
drsh() {
  dr exec -it "$1" bash
}

# Docker Compose
: "${DOCKER_COMPOSE_APP:=docker compose}"
dc() {
  if [ -n "$ZSH_VERSION" ]; then
    ${=DOCKER_COMPOSE_APP} "$@"
  else
    $DOCKER_COMPOSE_APP "$@"
  fi
}
alias dcb='dc build'
alias dcbnc='dc build --no-cache'
alias dcu='dc up'
alias dcud="dc up -d"
alias dcd='dc down'
alias dcs='dc stop'
alias dcbu="dcb; dcu" # Build, up
alias dcub="dcu --build" # Build, up
alias dcr="dc restart"
alias dcl="dc logs -f"
alias dce="dc exec"
dcsh() {
  dc exec -it "$1" bash
}
alias dccs='dc config --services'
