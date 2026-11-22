#!/usr/bin/env bats

# create_link only uses sudo for unwritable paths, so temp dirs run without it.

setup() {
  CREATE_LINK="$BATS_TEST_DIRNAME/../bin/create_link"
  TEST_DIR="$(mktemp -d)"
  S="$TEST_DIR/src"
  D="$TEST_DIR/dest/target"
  TODAY=$(date "+%Y-%m-%d")
}

teardown() {
  rm -rf "$TEST_DIR"
}

assert_link() {
  [ -L "$S" ]
  [ "$(readlink "$S")" = "$D" ]
}

@test "no arguments prints usage and exits 0" {
  run bash "$CREATE_LINK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"usage:"* ]]
}

@test "source only: moves source to destination and links it" {
  echo hello > "$S"
  run bash "$CREATE_LINK" "$S" "$D"
  [ "$status" -eq 0 ]
  assert_link
  [ "$(cat "$D")" = hello ]
}

@test "destination only: links source to existing destination" {
  mkdir -p "$(dirname "$D")"
  echo there > "$D"
  run bash "$CREATE_LINK" "$S" "$D"
  [ "$status" -eq 0 ]
  assert_link
  [ "$(cat "$S")" = there ]
}

@test "both files exist: source is kept as a dated copy" {
  mkdir -p "$(dirname "$D")"
  echo new > "$S"
  echo old > "$D"
  run bash "$CREATE_LINK" "$S" "$D"
  [ "$status" -eq 0 ]
  assert_link
  [ "$(cat "$D")" = old ]
  [ "$(cat "$D-old-$TODAY")" = new ]
}

@test "third argument names the duplicate" {
  mkdir -p "$(dirname "$D")"
  echo new > "$S"
  echo old > "$D"
  run bash "$CREATE_LINK" "$S" "$D" "$TEST_DIR/backup"
  [ "$status" -eq 0 ]
  [ "$(cat "$TEST_DIR/backup")" = new ]
}

_both_dirs() {
  mkdir -p "$S" "$D"
  echo s > "$S/only-src"
  echo d > "$D/only-dest"
}

@test "both dirs, choice 1: merges source into destination" {
  _both_dirs
  run bash -c "echo 1 | bash '$CREATE_LINK' '$S' '$D'"
  [ "$status" -eq 0 ]
  assert_link
  [ -f "$D/only-src" ]
  [ -f "$D/only-dest" ]
}

@test "both dirs, choice 2: uses source, old destination kept as copy" {
  _both_dirs
  run bash -c "echo 2 | bash '$CREATE_LINK' '$S' '$D'"
  [ "$status" -eq 0 ]
  assert_link
  [ -f "$D/only-src" ]
  [ ! -e "$D/only-dest" ]
  [ -f "$D-old-$TODAY/only-dest" ]
}

@test "both dirs, choice 3: keeps destination, source kept as copy" {
  _both_dirs
  run bash -c "echo 3 | bash '$CREATE_LINK' '$S' '$D'"
  [ "$status" -eq 0 ]
  assert_link
  [ -f "$D/only-dest" ]
  [ -f "$D-old-$TODAY/only-src" ]
}

@test "both dirs, invalid choice: aborts and changes nothing" {
  _both_dirs
  run bash -c "echo x | bash '$CREATE_LINK' '$S' '$D'"
  [ "$status" -eq 1 ]
  [ -d "$S" ] && [ ! -L "$S" ]
  [ -f "$S/only-src" ]
  [ -f "$D/only-dest" ]
}

@test "source already a symlink: refuses" {
  ln -s /tmp "$S"
  run bash "$CREATE_LINK" "$S" "$D"
  [ "$status" -eq 1 ]
  [[ "$output" == *"already a symlink"* ]]
  [ "$(readlink "$S")" = /tmp ]
}

@test "destination symlink is replaced by the source" {
  mkdir -p "$(dirname "$D")"
  ln -s /tmp "$D"
  echo hello > "$S"
  run bash "$CREATE_LINK" "$S" "$D"
  [ "$status" -eq 0 ]
  assert_link
  [ ! -L "$D" ]
  [ "$(cat "$D")" = hello ]
}

@test "neither exists: exits 0 without creating a link" {
  run bash "$CREATE_LINK" "$S" "$D"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Neither location exists"* ]]
  [ ! -e "$S" ] && [ ! -L "$S" ]
}
