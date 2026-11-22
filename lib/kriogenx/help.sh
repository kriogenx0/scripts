# shellcheck shell=bash
# kriogenx: `kriogenx help`

_krio_help() {
  printf "\033[0;33mkriogenx\033[0m — developer environment toolkit\n\n"
  printf "\033[0;33mServices:\033[0m\n"
  _krio_status
  printf "\n"
  printf "\033[0;33mUsage:\033[0m  kriogenx <command> [args]\n"
  printf "        kk <command> [args]\n\n"
  printf "\033[0;33mServices:\033[0m\n"
  printf "  nginx  [cmd]           Manage nginx    (s/q/t/config)\n"
  printf "  postgres [cmd]         Manage Postgres (s/q/t)\n"
  printf "  redis  [cmd]           Manage Redis    (s/q)\n\n"
  printf "\033[0;33mSetup:\033[0m\n"
  printf "  install <what>         Install a tool (xcode/homebrew/git/tig/ssh/docker)\n"
  printf "                           Languages via mise: go / node / python / ruby / rust\n"
  printf "                           Groups: essentials / languages / all\n"
  printf "  pimp-my-shell          Setup ZSH with oh-my-zsh and kriogenx theme\n"
  printf "  pimp-my-git            Configure git with sensible defaults\n"
  printf "  profile-scripts        Setup shell profile (.profile, .zshrc, .bashrc)\n"
  printf "  macos-hacks            Apply macOS system tweaks\n\n"
  printf "\033[0;33mManagement:\033[0m\n"
  printf "  update                 Update kriogenx, Homebrew, mise languages, oh-my-zsh\n\n"
  printf "\033[0;33mInfo:\033[0m\n"
  printf "  version                Show version info\n"
  printf "  release <part>         Bump VERSION + tag (major/minor/patch/current)\n"
  printf "  help                   Show this help\n\n"
}
