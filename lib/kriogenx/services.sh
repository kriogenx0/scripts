# shellcheck shell=bash
# kriogenx: local service management (nginx, postgres, redis)

_nginx() {
  case "$1" in
    s|start)
      if sudo nginx; then printf "nginx started\n"; else printf "nginx failed to start\n"; fi
      ;;
    q|quit|stop)
      if sudo nginx -s quit; then printf "nginx stopped\n"; else printf "nginx failed to stop\n"; fi
      ;;
    c|conf|config) vi /usr/local/etc/nginx/nginx.conf ;;
    t|status)
      if ps aux | grep nginx | grep -v grep >/dev/null; then printf "Running\n"; else printf "Not running\n"; fi
      ;;
    *)
      printf "\033[0;37;1mnginx\033[0m\n"
      printf "  s | start     Start\n"
      printf "  q | quit      Stop\n"
      printf "  c | config    Edit config file\n"
      ;;
  esac
}

_postgres() {
  case "$1" in
    s|start)     pg_ctl start ;;
    q|quit|stop) pg_ctl stop ;;
    t|status)    printf "PGDATA: %s\n" "$PGDATA" ;;
    *)
      printf "\033[0;37;1mpostgres\033[0m\n"
      printf "  s | start     Start\n"
      printf "  q | stop      Stop\n"
      ;;
  esac
}

_redis() {
  case "$1" in
    s|start)     redis-server & ;;
    q|quit|stop) _killps redis-server ;;
    *)
      printf "\033[0;37;1mredis\033[0m\n"
      printf "  s | start     Start\n"
      printf "  q | stop      Stop\n"
      ;;
  esac
}

_krio_status() {
  local any=0
  _svc_line() {
    local name="$1" check="$2"
    if eval "$check" &>/dev/null; then
      printf "  %-22s \033[0;32mrunning\033[0m\n" "$name"
      any=1
    fi
  }
  _svc_line "nginx"    "ps ax | grep 'nginx: master' | grep -v grep"
  _svc_line "postgres" "ps ax | grep 'postgres -D' | grep -v grep"
  _svc_line "redis"    "ps ax | grep redis-server | grep -v grep"
  _svc_line "colima"   "ps ax | grep 'colima daemon' | grep -v grep"
  [[ $any -eq 0 ]] && printf "  no services running\n"
}
