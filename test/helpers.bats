#!/usr/bin/env bats

setup() {
  LIBRARY_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  TEST_DIR="$(mktemp -d)"
}

teardown() {
  rm -rf "$TEST_DIR"
}

@test "profile setup preserves custom content and is repeatable with spaces in paths" {
  mkdir -p "$TEST_DIR/home space" "$TEST_DIR/library space/configs/rc"
  printf '# custom settings\n' > "$TEST_DIR/home space/.zshrc"
  printf ':\n' > "$TEST_DIR/library space/configs/rc/bashrc"
  for attempt in 1 2; do
    run env HOME="$TEST_DIR/home space" KRIO_DIR="$TEST_DIR/library space" bash "$LIBRARY_DIR/bin/profile-scripts"
    [ "$status" -eq 0 ]
  done
  [ "$(grep -c 'source ~/.profile' "$TEST_DIR/home space/.zshrc")" -eq 1 ]
  grep -q '^# custom settings$' "$TEST_DIR/home space/.zshrc"
  [ "$(grep -c 'configs/rc/bashrc' "$TEST_DIR/home space/.profile")" -eq 1 ]
  run env HOME="$TEST_DIR/home space" bash -c 'source "$HOME/.profile"'
  [ "$status" -eq 0 ]
}

@test "msg prints percent sequences as literal text" {
  run env TERM=xterm bash "$LIBRARY_DIR/bin/msg" '100% done %s' green
  [ "$status" -eq 0 ]
  [[ "$output" == *'100% done %s'* ]]
}

@test "create_link rejects a missing destination without changing the source" {
  printf 'keep me\n' > "$TEST_DIR/source"
  run bash "$LIBRARY_DIR/bin/create_link" "$TEST_DIR/source"
  [ "$status" -eq 1 ]
  [ "$(cat "$TEST_DIR/source")" = 'keep me' ]
}
