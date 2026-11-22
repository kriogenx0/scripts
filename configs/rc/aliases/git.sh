# shellcheck shell=bash
# Kriogenx aliases: git

#####################
# git

: "${GIT_DEV_BRANCH:=develop}"
: "${GIT_MAIN_BRANCH:=main}"

gcl() {
  local repo="$1" host="${2:-github.com}" dir
  if [[ "$repo" != *:* ]]; then
    repo="git@$host:$repo"
  fi
  git clone "$repo" || return
  dir="$(basename "$repo" .git)"
  cd "$dir" || return
}

# Adding
alias ga='git add -Av .; git status'
alias gar='git reset HEAD'
alias gai='git add -i; git status'
alias gap='git add -p'

# Committing
alias gc='git commit -v -m'
alias gca='git commit --amend --no-edit'
alias gcaa='git commit --amend'

# Checking out
alias gco="git checkout"
alias go="git checkout"

# Checkout Remote
gor() {
  local branch
  branch=$(echo "$1" | sed -e 's/^[* ]*//' -e 's#remotes/origin/##')
  git checkout "$branch"
}
# Checkout first branch that matches search
gos() {
  local branch
  branch=$(git branch -a | grep "$1" | sed -e 's/^[* ]*//' -e 's#remotes/origin/##' | head -n1)
  [[ -n $branch ]] && git checkout "$branch"
}
alias gom="git checkout $GIT_MAIN_BRANCH"
god() {
  git checkout "$GIT_DEV_BRANCH"
}
alias gol="git checkout -" # checkout last branch
gob() { # go back a branch
  git checkout @\{-"$1"\}
}

# Branches
alias gb='git branch'

# Current branch
alias gbc="git branch --no-color | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'" # branch current

# Show Branches in order
gbb() {
  git branch | sed '/\*/d' | while read -r k; do
    echo "$(git log -1 --pretty=format:"%ct" "$k") $k"
  done | sort -r | awk '{print $2}'
}
alias gbd='git branch -d'
alias gbdd='git branch -D' # force delete
alias gbup='git branch --set-upstream-to=origin/`gbc`'

# Recreate branch
gbddd() {
  local branch
  branch=$(gbc)
  [[ -n $branch ]] || { echo "no current branch"; return 1; }
  god
  gbdd "$branch"
}

# delete remote
gbdr() {
  git push origin ":$1"
}
# delete all branches
gbda() {
  gbdd "$1"
  gbdr "$1"
}

alias gbp='git prune -v'
alias gbpr='git remote prune origin'

# All Branches
alias gba='git branch -a' # all branches

# Remote Branches
alias gbr='git branch -r' # remote branches

# Search Branches
alias gbs='git branch -a | grep' # search branches

alias gbm="git branch --merged"
gbmc() {
  git branch --merged "$(gbc)"
}
alias gbnm="git branch --no-merged"

# These used to be aliases; drop them so re-sourcing doesn't clash
unalias gbmm gbmd gbdm gbdmd gbdmc 2>/dev/null

# Resolve the repo's main branch: $GIT_MAIN_BRANCH if it exists locally,
# else origin's HEAD, else main/master, whichever exists.
git_main_branch() {
  local b
  for b in "$GIT_MAIN_BRANCH" \
    "$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')" \
    main master; do
    [[ -n $b ]] && git show-ref --verify --quiet "refs/heads/$b" && { echo "$b"; return 0; }
  done
  return 1
}

# List local branches merged into $1 (plain names, no `*`/`+` markers, no
# detached HEAD), excluding $1 itself and any branch checked out in a
# worktree (which includes the current branch).
_git_merged_into() {
  local base=$1
  [[ -z $base ]] && { echo "No base branch found" >&2; return 1; }
  git show-ref --verify --quiet "refs/heads/$base" || { echo "Branch '$base' does not exist" >&2; return 1; }
  git for-each-ref --merged="$base" \
    --format='%(if)%(worktreepath)%(then)%(else)%(refname:short)%(end)' refs/heads/ |
    grep -vxF -e "$base" -e ''
}

# Delete local branches merged into $1 after confirmation (no-op if none).
# Pass -y as $2 to skip the prompt.
_git_delete_merged_into() {
  local base=$1 branches yn
  branches=$(_git_merged_into "$base") || return
  if [[ -z $branches ]]; then
    echo "No branches merged into $base"
    return 0
  fi
  echo "Branches merged into $base:"
  # shellcheck disable=SC2001 # per-line indent; ${//} differs in zsh
  echo "$branches" | sed 's/^/  /'
  if [[ $2 != "-y" ]]; then
    printf "Delete these branches? [y/N] "
    read -r yn
    [[ $yn =~ ^([yY]|[yY][eE][sS])$ ]] || { echo "Aborted"; return 0; }
  fi
  echo "$branches" | xargs git branch -d
}

# Branches Merged into main
gbmm() { _git_merged_into "$(git_main_branch)"; }

# Branches Merged into Dev
gbmd() { _git_merged_into "$GIT_DEV_BRANCH"; }

# Branch Delete Merged into main (gbdm -y to skip confirmation)
gbdm() { _git_delete_merged_into "$(git_main_branch)" "$1"; }

# Branch Delete Merged into Develop (gbdmd -y to skip confirmation)
gbdmd() { _git_delete_merged_into "$GIT_DEV_BRANCH" "$1"; }

# Branch Delete Merged into Current (gbdmc -y to skip confirmation)
gbdmc() { _git_delete_merged_into "$(gbc)" "$1"; }

# Remote Branches merged into main
alias gbrm="gbr --merged $GIT_MAIN_BRANCH | grep -v $GIT_MAIN_BRANCH | sed 's/^  origin\///g'"

# Remote Branches not merged
alias gbrnm="gbr --no-merged $GIT_MAIN_BRANCH | sed 's/^  origin\///g'"

# Remote Branches Delete Merged into main
gbrdm(){
  local i
  for i in $(git branch -r --merged "$GIT_MAIN_BRANCH" | sed 's/^  origin\///g'); do
    if [[ $i != "$GIT_MAIN_BRANCH" && $i != 'HEAD' && $i != '->' && $i != "origin/$GIT_MAIN_BRANCH" ]]; then
      gbdr "$i"
    fi
  done
}

alias gbo='git checkout -b'
gbu() {
  gbo "$1"
  git push -u origin "$1"
}
gbt() {
  git branch -t "$1" origin/"$1"; #origin/"$1";
  git checkout "$1"
}

alias gts='git show'

# Git Tags
alias gt='git tag'
alias gtg='git tag'
alias gtp='git push --tags'
alias gtd='git tag -d'
gtdr() { # DELETE REMOTE TAG
  git push origin ":refs/tags/$1"
}
gtda() {
  gtd "$1"
  gtdr "$1"
}
gtdc() {
  gtda "$1"
  gtg "$1"
  gtp
}

# status / diffs
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gdc='git diff --cached'
alias gad='ga; gds'
alias gdl="git show" # diff last changes
alias gdh='git diff HEAD'
alias gdm="git diff $GIT_MAIN_BRANCH"
alias gdd="git diff $GIT_DEV_BRANCH"
alias gsha='git log | head -1'

# logging - glo
alias glod='git log --oneline --decorate'
alias glop='git log -p'
alias glol='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias glola='git log --graph --decorate --pretty=oneline --abbrev-commit --all'
alias glodd='git log --pretty=format:"%h%x09%an%x09%ad%x09%s"'
alias glodr='git log --pretty=format:"%h%x09%an%x09%ad%x09%s" --date=relative'
# See a branch's commits
gbl() {
  glop "$GIT_MAIN_BRANCH..$(gbc)" --no-merges
}
alias gbld='glop develop..`gbc` --no-merges' # See a branch's commits
alias gls='git ls-files'
alias glgn='ls-files -o -i --exclude-standard' # Show files ignored by git:
alias glc="git cherry -v $GIT_MAIN_BRANCH" #show changes in branch not merged
alias gcp="git cherry-pick"

# Git Push
alias gp='git push'
alias gpa='git push --all'
alias gpu='git push -u'
alias gpo='git push -u origin `gbc`'
alias gpcr='git push origin `gbc`:'

# Git Pull
alias gl='git pull'
alias gla='git pull -v --all'
glu() {
  git branch --set-upstream-to "$(gbc)" "origin/$(gbc)"
}
alias glr='git pull --rebase'
alias gln='glr; gbpr; gbdm' # Git Pull Sync - Pull Rebase, Prune Branches, Deleted Merged
alias gnc='glr; gp; gbpr' # Git Sync - Pull Rebase, Push, Prune Branches
alias glm="gom; glr; gol; glr" # Pull main and go back to branch

# Git Rebasing
alias gr='git rebase'
alias grc='git rebase --continue'
alias grs='git rebase --skip'
alias gra='git rebase --abort'
alias grd="git rebase $GIT_DEV_BRANCH"
alias grm="git rebase $GIT_MAIN_BRANCH"
alias gri='git rebase -i'

# Git Misc
alias gups='git branch --set-upstream-to=origin/`gbc` `gbc`'

# Undos a commit from given hash
gundocommit() {
  # TODO: message for excluding hash
  git rebase --onto "$1"^ "$1"
}

# Git Stashes
alias gst='git stash show'
alias gstl='git stash list'
alias gsd='git stash drop'
alias gss='git stash save'
alias gsr='git reset' # Unstage all files
alias gsa='git stash apply'
alias gsad='git stash apply; git stash drop'
alias gsc='git stash clear'
alias gsn='ga; gss; glr; gsa'

alias gm='git merge'
alias gmt='git mergetool'
alias gmf='git merge --no-commit --no-ff -v'
alias gmm="git merge $GIT_MAIN_BRANCH"
alias gmd="git merge $GIT_DEV_BRANCH"

# ignore file
alias gig="vi .gitignore"
alias gigi="git update-index --assume-unchanged" # then filename, used for ignoring changes to a file locally
alias gigu="git update-index --no-assume-unchanged" # then filename, used for ignoring changes to a file locally

alias grev='git revert'
alias gcundo='git reset --hard HEAD~1' # undo last commit
alias gsundo='git reset --soft HEAD^'
alias grundo='git revert HEAD~1 -n' #undo commit changes, leaving commit alone
gundo() {
  local n=${1:-1}
  git revert -n "HEAD~$n"
}

# Git Submodules
alias gsm='git submodule add'
alias gsl='git submodule foreach git pull origin $GIT_MAIN_BRANCH'
alias gsu="git submodule update --init; git submodule update"

# Cleaning & Clearing
alias gclr='git clean -fd; git checkout -f'
alias gclrf='gclr; git clean -fxd'
alias gfix='git gc; git remote prune origin; git repack; git fsck --full --progress'
alias gclean="gbdmd; gbp; gbpr"

# Config
alias gconf='vi .git/config'
alias ggconf='vi ~/.gitconfig'

gsearch() {
  # shellcheck disable=SC2046 # intentionally unquoted: expands to multiple commit SHAs
  git grep "$1" $(git rev-list --all)
}
gitpermanentfiledelete() {
  local target="$1"
  git filter-branch --force --index-filter "git rm --cached --ignore-unmatch '$target'" --prune-empty --tag-name-filter cat -- --all
}


# tig
alias tiga='tig --all'
alias tigs='tig status'
