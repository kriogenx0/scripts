#!/usr/bin/env bats

KRIO="$BATS_TEST_DIRNAME/../bin/kriogenx"

setup() {
  export KRIO_DIR="$BATS_TEST_DIRNAME/.."
}

@test "help exits 0 and prints usage" {
  run "$KRIO" help
  [ "$status" -eq 0 ]
  [[ "$output" == *"kriogenx"* ]]
  [[ "$output" == *"Usage:"* ]]
}

@test "no command defaults to help" {
  run "$KRIO"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "unknown command exits 1 and prints usage to stderr" {
  run "$KRIO" bogus-command
  [ "$status" -eq 1 ]
  [[ "$output" == *"unknown command"* ]]
}

@test "install with no argument prints the package menu and exits 0" {
  run "$KRIO" install
  [ "$status" -eq 0 ]
  [[ "$output" == *"available packages"* ]]
  [[ "$output" == *"xcode"* ]]
}

@test "install lists all language toolchains" {
  run "$KRIO" install
  [[ "$output" == *"go"* ]]
  [[ "$output" == *"node"* ]]
  [[ "$output" == *"python"* ]]
  [[ "$output" == *"ruby"* ]]
  [[ "$output" == *"rust"* ]]
}

@test "version exits 0 and prints something" {
  run "$KRIO" version
  [ "$status" -eq 0 ]
  [[ "$output" == kriogenx* ]]
}

@test "version reports the VERSION file" {
  run "$KRIO" version
  [[ "$output" == "kriogenx $(tr -d '[:space:]' < "$KRIO_DIR/VERSION")"* ]]
}

@test "VERSION is semver and has a CHANGELOG entry" {
  v=$(tr -d '[:space:]' < "$KRIO_DIR/VERSION")
  [[ $v =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
  grep -q "^## \[$v\]" "$KRIO_DIR/CHANGELOG.md"
}

@test "release with no part prints usage and exits 1" {
  run "$KRIO" release
  [ "$status" -eq 1 ]
  [[ "$output" == *"Usage: kriogenx release"* ]]
}

@test "install menu lists docker and the install groups" {
  run "$KRIO" install
  [[ "$output" == *"docker"* ]]
  [[ "$output" == *"essentials"* ]]
  [[ "$output" == *"languages"* ]]
}

# --- release: runs against a throwaway repo via KRIO_DIR ---

_release_repo() {
  RELEASE_DIR="$(mktemp -d)"
  export KRIO_DIR="$RELEASE_DIR" GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t \
    GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
  cd "$RELEASE_DIR" || return 1
  git init -q -b master
  echo 1.2.3 > VERSION
  printf '# Changelog\n\n## [1.2.3]\n' > CHANGELOG.md
  git add . && git commit -qm init
}

@test "release current tags the existing version" {
  _release_repo
  run bash -c "echo y | '$KRIO' release current"
  [ "$status" -eq 0 ]
  git rev-parse -q --verify refs/tags/v1.2.3
  run bash -c "echo y | '$KRIO' release current"
  [ "$status" -eq 1 ]
  [[ "$output" == *"tag v1.2.3 already exists"* ]]
  rm -rf "$RELEASE_DIR"
}

@test "release minor requires a changelog section, then commits and tags" {
  _release_repo
  run bash -c "echo y | '$KRIO' release minor"
  [ "$status" -eq 1 ]
  [[ "$output" == *"add a '## [1.3.0]' section"* ]]
  printf '\n## [1.3.0]\n- new\n' >> CHANGELOG.md   # uncommitted changelog is allowed
  run bash -c "echo y | '$KRIO' release minor"
  [ "$status" -eq 0 ]
  [ "$(cat VERSION)" = 1.3.0 ]
  [ "$(git log -1 --format=%s)" = "Release v1.3.0" ]
  git rev-parse -q --verify refs/tags/v1.3.0
  [ -z "$(git status --porcelain)" ]
  rm -rf "$RELEASE_DIR"
}

@test "release refuses other uncommitted changes" {
  _release_repo
  echo x > other.txt
  run bash -c "echo y | '$KRIO' release current"
  [ "$status" -eq 1 ]
  [[ "$output" == *"commit or stash your changes first"* ]]
  rm -rf "$RELEASE_DIR"
}

@test "release answered no changes nothing" {
  _release_repo
  printf '\n## [2.0.0]\n' >> CHANGELOG.md
  run bash -c "echo n | '$KRIO' release major"
  [ "$status" -eq 0 ]
  [ "$(cat VERSION)" = 1.2.3 ]
  ! git rev-parse -q --verify refs/tags/v2.0.0
  rm -rf "$RELEASE_DIR"
}
