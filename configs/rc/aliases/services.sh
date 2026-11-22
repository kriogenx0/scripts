# shellcheck shell=bash
# Kriogenx aliases: services

# Nginx
alias ngsites='vi /usr/local/etc/nginx/nginx.conf'
alias ngstart='sudo nginx'
alias ngstop='sudo nginx -s quit'


# postgres
alias pgstart='pg_ctl start'
alias pgstop='pg_ctl stop'
pgenv() {
  echo "PGDATA:    $PGDATA"
}
