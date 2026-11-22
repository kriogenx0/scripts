# shellcheck shell=bash
# kriogenx: `kriogenx update`

_krio_update() {
  printf "\033[0;33mKriogenx\033[0m — Updating...\n"
  (cd "$KRIO_DIR" && git pull --rebase)

  if command -v brew &>/dev/null; then
    printf "\033[0;33mBrew\033[0m — Updating...\n"
    brew update && brew upgrade && brew cleanup
  fi

  if command -v mise &>/dev/null; then
    # A Homebrew-installed mise is upgraded by `brew upgrade` above
    if ! { command -v brew &>/dev/null && brew list --formula mise &>/dev/null; }; then
      printf "\033[0;33mmise\033[0m — Updating...\n"
      mise self-update --yes
    fi
    printf "\033[0;33mLanguages\033[0m — Upgrading via mise...\n"
    mise upgrade --yes
  fi

  if [[ -d ~/.oh-my-zsh ]]; then
    printf "\033[0;33mOH-MY-ZSH\033[0m — Updating...\n"
    (cd ~/.oh-my-zsh && git pull --rebase -q && git submodule foreach git pull origin master)
  fi
}
