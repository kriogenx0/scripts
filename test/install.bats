#!/usr/bin/env bats

# Installers run against fake brew/mise/colima/docker that log their calls,
# with PATH limited so the real tools are never reached.

setup() {
  ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  TEST_DIR="$(mktemp -d)"
  FAKE="$TEST_DIR/fakebin"
  CALLS="$TEST_DIR/calls"
  export HOME="$TEST_DIR/home" CALLS
  export BREW_STATE="$TEST_DIR/brew"
  mkdir -p "$FAKE" "$HOME" "$BREW_STATE/installed"
  : > "$CALLS"

  ln -s "$(command -v bash)" "$FAKE/bash"

  # brew: tracks installed formulae as files
  cat > "$FAKE/brew" <<'EOF'
#!/usr/bin/env bash
echo "brew $*" >> "$CALLS"
case "$1" in
  --prefix) echo "$BREW_STATE" ;;
  list) [[ -e "$BREW_STATE/installed/${@: -1}" ]] ;;
  install) shift; for f in "$@"; do touch "$BREW_STATE/installed/$f"; done ;;
esac
EOF
  # mise / colima / docker: just log
  for tool in mise docker; do
    printf '#!/usr/bin/env bash\necho "%s $*" >> "$CALLS"\n' "$tool" > "$FAKE/$tool"
  done
  # colima: not running until started
  cat > "$FAKE/colima" <<'EOF'
#!/usr/bin/env bash
echo "colima $*" >> "$CALLS"
[[ $1 == status ]] && exit 1
exit 0
EOF
  chmod +x "$FAKE"/*
  export PATH="$FAKE:/usr/bin:/bin"
}

teardown() {
  rm -rf "$TEST_DIR"
}

# ---------- docker ----------

@test "docker: installs missing formulae, links CLI plugins, starts colima" {
  run "$ROOT/libexec/install/docker"
  [ "$status" -eq 0 ]
  grep -qx "brew install docker docker-compose docker-buildx docker-credential-helper colima" "$CALLS"
  [ "$(readlink "$HOME/.docker/cli-plugins/docker-compose")" = "$BREW_STATE/opt/docker-compose/bin/docker-compose" ]
  [ "$(readlink "$HOME/.docker/cli-plugins/docker-buildx")" = "$BREW_STATE/opt/docker-buildx/bin/docker-buildx" ]
  grep -qx "colima start" "$CALLS"
}

@test "docker: second run installs nothing" {
  "$ROOT/libexec/install/docker" >/dev/null
  : > "$CALLS"
  run "$ROOT/libexec/install/docker"
  [ "$status" -eq 0 ]
  [[ "$output" == *"already installed"* ]]
  ! grep -q "^brew install" "$CALLS"
}

@test "docker: DOCKER_EXTRAS adds formulae and COLIMA_ARGS reach colima" {
  DOCKER_EXTRAS="lazydocker dive" COLIMA_ARGS="--cpu 4" run "$ROOT/libexec/install/docker"
  [ "$status" -eq 0 ]
  grep -q "^brew install .* lazydocker dive$" "$CALLS"
  grep -qx "colima start --cpu 4" "$CALLS"
}

@test "docker: repairs a leftover Docker Desktop credsStore" {
  mkdir -p "$HOME/.docker"
  printf '{\n  "credsStore": "desktop"\n}\n' > "$HOME/.docker/config.json"
  run "$ROOT/libexec/install/docker"
  [ "$status" -eq 0 ]
  grep -q '"credsStore": "osxkeychain"' "$HOME/.docker/config.json"
  grep -q '"credsStore": "desktop"' "$HOME/.docker/config.json.bak"
}

@test "docker: fails clearly without Homebrew" {
  rm "$FAKE/brew"
  run "$ROOT/libexec/install/docker"
  [ "$status" -eq 1 ]
  [[ "$output" == *"Homebrew is required"* ]]
}

# ---------- languages ----------

@test "languages: no arguments prints usage and exits 1" {
  run "$ROOT/libexec/install/languages"
  [ "$status" -eq 1 ]
  [[ "$output" == *"usage:"* ]]
}

@test "languages: unsupported language exits 1 before installing anything" {
  run "$ROOT/libexec/install/languages" node cobol
  [ "$status" -eq 1 ]
  [[ "$output" == *"Unsupported language: cobol"* ]]
  [ ! -s "$CALLS" ]
}

@test "languages: installs mise via brew when missing, node defaults to LTS" {
  rm "$FAKE/mise"
  # brew install mise "provides" a mise binary
  cat >> "$FAKE/brew" <<EOF
[[ "\$(tail -n 1 "\$CALLS")" == "brew install mise" ]] && printf '#!/usr/bin/env bash\necho "mise \$*" >> "\$CALLS"\n' > "$FAKE/mise" && chmod +x "$FAKE/mise"
EOF
  run "$ROOT/libexec/install/languages" node
  [ "$status" -eq 0 ]
  grep -qx "brew install mise" "$CALLS"
  grep -qx "mise use --global --yes node@lts" "$CALLS"
}

@test "languages: KRIO_<LANG>_VERSION picks the version; ruby gets build deps" {
  KRIO_RUBY_VERSION=3.3 run "$ROOT/libexec/install/languages" ruby
  [ "$status" -eq 0 ]
  grep -qx "brew install libyaml openssl@3 readline" "$CALLS"
  grep -qx "mise use --global --yes ruby@3.3" "$CALLS"
}

@test "languages: all installs every toolchain" {
  run "$ROOT/libexec/install/languages" all
  [ "$status" -eq 0 ]
  for lang in ruby@latest node@lts python@latest rust@latest go@latest; do
    grep -qx "mise use --global --yes $lang" "$CALLS"
  done
}

# ---------- kriogenx dispatch ----------

@test "kriogenx install <lang> and the kriogenx <lang> shortcut both use mise" {
  run "$ROOT/bin/kriogenx" install go
  [ "$status" -eq 0 ]
  run "$ROOT/bin/kriogenx" python
  [ "$status" -eq 0 ]
  grep -qx "mise use --global --yes go@latest" "$CALLS"
  grep -qx "mise use --global --yes python@latest" "$CALLS"
}

@test "kriogenx install docker runs the docker installer" {
  run "$ROOT/bin/kriogenx" install docker
  [ "$status" -eq 0 ]
  grep -q "^brew install docker" "$CALLS"
}

@test "kriogenx install with an unknown package exits 1" {
  run "$ROOT/bin/kriogenx" install bogus
  [ "$status" -eq 1 ]
  [[ "$output" == *"unknown package 'bogus'"* ]]
}
