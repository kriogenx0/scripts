# Kriogenx ZSH Theme
# Used a big part of...
#
# Fino theme by Max Masnick (http://max.masnick.me)

# Use with a dark background and 256-color terminal!
# Meant for people with RVM and git. Tested only on OS X 10.8.

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    echo '○'
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

function time_stamp {
  #echo -n $(date "+%Y-%m-%d %H:%M:%S") | sed "s/^\dm\"//"
  echo -n $(date "+%m-%d %H:%M:%S") | sed "s/^\dm\"//"
}


# Local Vars
local rvm_ruby=''
if which rvm-prompt &> /dev/null; then
  rvm_ruby='‹$(rvm-prompt i v g)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm_ruby='‹$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
  fi
fi
local current_dir='${PWD/#$HOME/~}'
local git_info='$(git_prompt_info)'
local theme_time=' $(time_stamp)'

# %{$FG[040]%}%n%{$reset_color%} %{$FG[033]%}$(box_name)%{$reset_color%} 
PROMPT="╭─ %{$terminfo[bold]$FG[226]%}${current_dir}%{$reset_color%}${git_info} ${rvm_ruby}${theme_time}
╰─$(virtualenv_info) "
#╰─$(virtualenv_info)$(prompt_char) "

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%}✘✘✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%}✔"
