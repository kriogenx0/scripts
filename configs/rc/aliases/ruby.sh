# shellcheck shell=bash
# Kriogenx aliases: ruby

####################
# RUBY & RAILS

alias rb='ruby'
alias rrvm='vi .rvmrc'
alias rcuc='cd `rr`; bundle exec cucumber'
alias rversions="gem list -ra rails | grep 'rails ('"
alias rgems='rvm list gemsets; cat .rvmrc'
alias rgemsdir='cd `rvm gemdir`/gems'
alias rvdgems='rvm gemset empty'
alias rgem='vi `rr`/Gemfile'
# Install a Ruby version with mise if present, else RVM
_ruby_install_version() {
  if command -v mise >/dev/null 2>&1; then
    mise install "ruby@$1"
  else
    rvm install "$1"
  fi
}
rinstall() {
  if [[ -n $1 ]]; then
    _ruby_install_version "$1"
    cd - || return; cd - || return
    gem install bundler
    bundle install
  else
    echo 'Must supply ruby version'
  fi
}
rgemsuninstall(){
  for i in `gem list --no-versions`; do
    gem uninstall -aIx "$i";
  done
}
alias rgembuild='gem pristine --all --no-extensions'
alias rlog='tail -f `rr`/log/development.log'
alias rtlog='tail -f `rr`/log/test.log'
# Rails Root
rr() {
  dirup config/environment.rb
}
rsc() {
  if [[ -f "$(rr)/script/rails" ]]; then
    "$(rr)/script/rails" console
  elif [[ -f "$(rr)/script/console" ]]; then
    "$(rr)/script/console"
  else
    rails c
  fi
}
rss() {
  if [[ -f "`rr`/script/rails" ]]; then
    S="rails server"
  elif [[ -f "`rr`/script/server" ]]; then
    S="`rr`/script/server"
  else
    S="rails s"
  fi
  if [[ -n $1 ]]; then
    eval "$S -p '$1'"
  else
    eval "$S"
  fi
}
alias rss1='rss 3001'
alias rss2='rss 3002'
alias rss3='rss 3003'

alias bex="bundle exec"

rup() {
  _ruby_install_version "$(cat .ruby-version)"
  gem install bundler
  bundle
}

alias railsg="rails generate --no-helper --no-assets --no-controller-specs --no-view-specs"

[[ `which rake` =~ 'aliased to _rake_command' ]] && unalias rake


# cucumber
alias cuc='cucumber --format pretty -v'
alias cucb='bex cucumber --format pretty -v'
cucf() {
  if [[ -n "$1" ]]; then
    cucb "features/""${1/\.feature/}"".feature"
  else
    ls features/*.feature 2>/dev/null
  fi
}
