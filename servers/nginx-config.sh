if [[ -e /usr/local/etc/nginx ]]; then
  mkdir /usr/local/etc/nginx/projects
  ln -s /usr/local/etc/nginx/projects ~/Sites/webconfig/nginx-projects
fi
