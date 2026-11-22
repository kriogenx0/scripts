# shellcheck shell=bash
# kriogenx: `kriogenx install <what>`
# Small installs live here; bigger ones are scripts in libexec/install/.

KRIO_LANGUAGES=(ruby node python rust go)

_install_xcode() {
  local result
  result=$(xcode-select -p 2>&1)
  if [[ $result =~ 'not found' ]]; then
    printf "\033[0;36mInstalling Xcode Command Line Tools...\033[0m\n"
    xcode-select --install
  elif [[ -z $result ]]; then
    printf "\033[0;36mSelecting Xcode install...\033[0m\n"
    local xcode_dev=/Applications/Xcode.app/Contents/Developer
    [[ -e $xcode_dev ]] && sudo xcode-select -switch "$xcode_dev"
  else
    printf "Xcode: already installed (%s)\n" "$result"
  fi
}

_install_homebrew() {
  if command -v brew &>/dev/null; then
    printf "Homebrew: already installed\n"
  else
    printf "\033[0;36mInstalling Homebrew...\033[0m\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

_install_git() {
  if [[ $(which git) =~ "usr/local" || $(which git) =~ "homebrew" ]]; then
    printf "\033[0;36mUpgrading git...\033[0m\n"
    brew upgrade git
  elif command -v brew &>/dev/null; then
    printf "\033[0;36mInstalling git...\033[0m\n"
    brew install git
  else
    printf "\033[0;36mInstalling git via apt...\033[0m\n"
    sudo apt-get install git -yf
  fi
}

_install_tig() {
  if command -v tig &>/dev/null; then
    printf "tig: already installed\n"
  else
    printf "\033[0;36mInstalling tig...\033[0m\n"
    brew install tig
  fi
}

_install_ssh() {
  if [[ -e ~/.ssh/id_rsa ]]; then
    printf "SSH: key already exists at ~/.ssh/id_rsa\n"
    return 0
  fi
  printf "\033[0;36mSetting up SSH key...\033[0m\n"
  local email
  read -rp "Enter your email address: " email
  if [[ -n $email ]]; then
    ssh-keygen -t rsa -C "$email"
    if [[ -e ~/.ssh/id_rsa ]]; then
      chmod 0600 ~/.ssh/id_rsa
      ssh-add ~/.ssh/id_rsa
      [[ -e ~/.ssh/id_rsa.pub ]] && pbcopy < ~/.ssh/id_rsa.pub && printf "Public key copied to clipboard\n"
      printf "Testing SSH connection to GitHub...\n"
      [[ $(ssh -T git@github.com 2>&1) =~ 'success' ]] && printf "SSH: connected\n" || printf "SSH: could not connect to GitHub\n"
    else
      printf "ERROR: SSH key generation failed\n"
    fi
  fi
}

# Dev tools only, no language toolchains
_install_essentials() {
  _install_xcode
  _install_homebrew
  _confirm "Install git?"                  && _install_git
  _confirm "Install tig (git log viewer)?" && _install_tig
  _confirm "Install Docker + Colima?"      && "$KRIO_LIBEXEC/install/docker"
  _confirm "Set up an SSH key?"            && _install_ssh
}

# Ask per language, then install the chosen ones in one mise run
_install_languages() {
  local lang chosen=()
  for lang in "${KRIO_LANGUAGES[@]}"; do
    _confirm "Install $lang (via mise)?" && chosen+=("$lang")
  done
  if [[ ${#chosen[@]} -eq 0 ]]; then
    printf "No languages selected\n"
    return 0
  fi
  "$KRIO_LIBEXEC/install/languages" "${chosen[@]}"
}

_install_help() {
  printf "\033[0;33minstall\033[0m — available packages\n\n"
  printf "\033[0;37mDev tools:\033[0m\n"
  printf "  xcode       Xcode Command Line Tools\n"
  printf "  homebrew    Homebrew package manager\n"
  printf "  git         Git version control\n"
  printf "  tig         Git log viewer (requires brew)\n"
  printf "  ssh         Generate and configure SSH key\n"
  printf "  docker      Docker, compose, buildx + Colima\n"
  printf "\n\033[0;37mLanguages (via mise):\033[0m\n"
  printf "  go          Go\n"
  printf "  node        Node.js (LTS)\n"
  printf "  python      Python\n"
  printf "  ruby        Ruby\n"
  printf "  rust        Rust\n"
  printf "\n\033[0;37mGroups:\033[0m\n"
  printf "  essentials  Dev tools only (no languages)\n"
  printf "  languages   Pick language toolchains\n"
  printf "  all         Essentials + languages\n\n"
}

_install() {
  local what="${1:-help}"
  shift 2>/dev/null || true
  case "$what" in
    xcode)           _install_xcode ;;
    homebrew|brew)   _install_homebrew ;;
    git)             _install_git ;;
    tig)             _install_tig ;;
    ssh)             _install_ssh ;;
    docker)          exec "$KRIO_LIBEXEC/install/docker" "$@" ;;
    ruby|node|python|rust|go)
      exec "$KRIO_LIBEXEC/install/languages" "$what" "$@"
      ;;
    essentials)
      _install_essentials
      printf "\n\033[0;32mDeveloper essentials complete\033[0m\n"
      ;;
    languages)
      _install_languages
      printf "\n\033[0;32mLanguages complete\033[0m\n"
      ;;
    all)
      _install_essentials
      _install_languages
      printf "\n\033[0;32mDeveloper setup complete\033[0m\n"
      ;;
    help|-h|--help)
      _install_help
      ;;
    *)
      printf "install: unknown package '%s'\n\n" "$what" >&2
      _install_help >&2
      return 1
      ;;
  esac
}
