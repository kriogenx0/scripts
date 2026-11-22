#!/usr/bin/env bats

ALIASESRC="$BATS_TEST_DIRNAME/../configs/rc/aliasesrc"

setup() {
  export TEST_DIR
  TEST_DIR="$(mktemp -d)"
}

teardown() {
  rm -rf "$TEST_DIR"
}

# --- dc / dcb: docker compose must resolve correctly under both bash and zsh ---

@test "dc (bash): resolves to docker compose as separate words" {
  run bash -c '
    shopt -s expand_aliases
    source "'"$ALIASESRC"'" >/dev/null 2>&1
    docker() { echo "CALLED:$*"; }
    dc ps
    dcb
  '
  [ "$status" -eq 0 ]
  [[ "$output" == *"CALLED:compose ps"* ]]
  [[ "$output" == *"CALLED:compose build"* ]]
}

@test "dc (zsh): resolves to docker compose as separate words" {
  run zsh -i -c '
    source "'"$ALIASESRC"'" >/dev/null 2>&1
    docker() { echo "CALLED:$*"; }
    dc ps
    dcb
  '
  [ "$status" -eq 0 ]
  [[ "$output" == *"CALLED:compose ps"* ]]
  [[ "$output" == *"CALLED:compose build"* ]]
}

# --- gitpermanentfiledelete: must actually remove the named file from history ---

@test "gitpermanentfiledelete removes the named file from all history" {
  cd "$TEST_DIR"
  git init -q
  git config user.email t@t.com
  git config user.name t
  echo secret > secret.txt
  echo keep > keep.txt
  git add -A && git commit -qm init

  run bash -c '
    source "'"$ALIASESRC"'" >/dev/null 2>&1
    gitpermanentfiledelete secret.txt
  '
  [ "$status" -eq 0 ]

  run git ls-tree -r --name-only HEAD
  [[ "$output" == *"keep.txt"* ]]
  [[ "$output" != *"secret.txt"* ]]
}

# --- mkd: must handle space-containing paths correctly ---

@test "mkd creates and enters a directory whose name contains spaces" {
  run bash -c '
    source "'"$ALIASESRC"'" >/dev/null 2>&1
    cd "'"$TEST_DIR"'"
    mkd "foo bar/baz qux"
    pwd
  '
  [ "$status" -eq 0 ]
  [[ "$output" == *"foo bar/baz qux"* ]]
}

# --- lss: must not fall through to an unfiltered listing on no match ---

@test "lss with a non-matching pattern prints nothing (does not fall through to full listing)" {
  cd "$TEST_DIR"
  touch alpha.txt beta.txt

  run bash -c '
    shopt -s expand_aliases
    source "'"$ALIASESRC"'" >/dev/null 2>&1
    cd "'"$TEST_DIR"'"
    lss zzz_no_such_match
  '
  [ "$status" -ne 0 ]
  [ -z "$output" ]
}

@test "lss with a matching pattern filters the listing" {
  cd "$TEST_DIR"
  touch alpha.txt beta.txt

  run bash -c '
    shopt -s expand_aliases
    source "'"$ALIASESRC"'" >/dev/null 2>&1
    cd "'"$TEST_DIR"'"
    lss alpha
  '
  [ "$status" -eq 0 ]
  [[ "$output" == *"alpha.txt"* ]]
  [[ "$output" != *"beta.txt"* ]]
}

# --- gbdm: delete branches merged into the main branch, with confirmation ---

_gbdm_repo() {
  cd "$TEST_DIR" || return 1
  git init -q -b "$1" repo && cd repo || return 1
  git -c user.name=t -c user.email=t@t commit -q --allow-empty -m init
  git branch merged-one
  git branch "$1-feature"   # name contains the main branch name
  git checkout -q --detach  # `git branch` shows "(HEAD detached ...)"
}

@test "gbdm works when the main branch is master, not \$GIT_MAIN_BRANCH" {
  _gbdm_repo master
  run bash -c 'source "'"$ALIASESRC"'" >/dev/null 2>&1; gbdm -y'
  [ "$status" -eq 0 ]
  [[ "$output" == *"Deleted branch merged-one"* ]]
  [[ "$output" == *"Deleted branch master-feature"* ]]
  [ "$(git branch --format='%(refname:short)' | grep -vc HEAD)" -eq 1 ]
}

@test "gbdm aborts without deleting when not confirmed (zsh)" {
  _gbdm_repo main
  run zsh -c 'source "'"$ALIASESRC"'" >/dev/null 2>&1; echo n | gbdm'
  [ "$status" -eq 0 ]
  [[ "$output" == *"Aborted"* ]]
  git show-ref --verify --quiet refs/heads/merged-one
}

@test "gbdm deletes after confirming (zsh)" {
  _gbdm_repo main
  run zsh -c 'source "'"$ALIASESRC"'" >/dev/null 2>&1; echo y | gbdm'
  [ "$status" -eq 0 ]
  ! git show-ref --verify --quiet refs/heads/merged-one
  git show-ref --verify --quiet refs/heads/main
}
