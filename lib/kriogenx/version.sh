# shellcheck shell=bash
# kriogenx: `kriogenx version` and `kriogenx release`

_krio_version() {
  local v
  v=$(tr -d '[:space:]' < "$KRIO_DIR/VERSION" 2>/dev/null)
  echo "${v:-unknown}"
}

# e.g. "kriogenx 1.4.0 (a5ed3b4)", or "(a5ed3b4-dirty)" with local changes
_krio_version_info() {
  local sha
  sha=$(cd "$KRIO_DIR" && git describe --always --dirty --abbrev=7 --match 'NO_TAGS' 2>/dev/null)
  if [[ -n $sha ]]; then
    printf "kriogenx %s (%s)\n" "$(_krio_version)" "$sha"
  else
    printf "kriogenx %s\n" "$(_krio_version)"
  fi
}

# Bump VERSION, commit, and tag vX.Y.Z (does not push)
_krio_release() {
  local part="${1:-}" cur major minor patch next
  cur=$(_krio_version)
  if ! [[ $cur =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    printf "release: VERSION '%s' is not X.Y.Z\n" "$cur" >&2; return 1
  fi
  major=${BASH_REMATCH[1]} minor=${BASH_REMATCH[2]} patch=${BASH_REMATCH[3]}
  case "$part" in
    major) next="$((major + 1)).0.0" ;;
    minor) next="$major.$((minor + 1)).0" ;;
    patch) next="$major.$minor.$((patch + 1))" ;;
    current) next="$cur" ;;
    *)
      printf "Usage: kriogenx release <major|minor|patch|current>\n" >&2
      printf "  current tags the existing VERSION (%s) without bumping\n" "$cur" >&2
      return 1
      ;;
  esac

  (
    cd "$KRIO_DIR" || exit 1
    if git rev-parse -q --verify "refs/tags/v$next" >/dev/null; then
      printf "release: tag v%s already exists\n" "$next" >&2; exit 1
    fi
    # Only CHANGELOG.md may be uncommitted; it goes into the release commit
    if [[ -n $(git status --porcelain -- . ':!CHANGELOG.md') ]]; then
      printf "release: commit or stash your changes first (CHANGELOG.md may be uncommitted)\n" >&2; exit 1
    fi
    if ! grep -q "^## \[$next\]" CHANGELOG.md 2>/dev/null; then
      printf "release: add a '## [%s]' section to CHANGELOG.md first\n" "$next" >&2; exit 1
    fi
    _confirm "Release v$next (current $cur)?" || exit 0
    [[ $next != "$cur" ]] && echo "$next" > VERSION
    if [[ -n $(git status --porcelain -- VERSION CHANGELOG.md) ]]; then
      git add VERSION CHANGELOG.md
      git commit -q -m "Release v$next"
    fi
    git tag -a "v$next" -m "kriogenx v$next"
    printf "\033[0;32mTagged v%s\033[0m — publish with: git push origin HEAD --follow-tags\n" "$next"
  )
}
