# Changelog

All notable changes to kriogenx are documented here.
Versions follow [Semantic Versioning](https://semver.org); the current
version lives in [`VERSION`](VERSION) and each release is tagged `vX.Y.Z`.

To cut a release: add a `## [X.Y.Z]` section below, then run
`kriogenx release <major|minor|patch>` (or `current` to tag `VERSION` as-is),
then `git push origin HEAD --follow-tags`.

## [Unreleased]

## [2.0.0] - 2026-11-16

First tagged release. Major version because commands were removed or moved
(see **Removed**).

### Added
- `kriogenx install docker`: Docker CLI, Compose, Buildx, credential helper
  and Colima via Homebrew; links CLI plugins, starts Colima, and repairs a
  leftover Docker Desktop `credsStore`.
- Languages via mise: `kriogenx install ruby|node|python|rust|go` (or
  `kriogenx <lang>`), with `KRIO_<LANG>_VERSION` to pick versions. `bashrc`
  activates mise; `kriogenx update` upgrades it.
- `kriogenx install essentials` and `kriogenx install languages` groups;
  `all` runs both.
- `VERSION` file, this changelog, and `kriogenx release`.
- `aliasrc <topic>` and `KRIOGENX_SKIP_ALIASES` to skip alias topics.
- `git_main_branch` helper; `gbdm`, `gbdmd`, `gbdmc` accept `-y`.
- `scripts/check` (syntax, ShellCheck, bats) locally and in CI; tests for
  `create_link`, the installers (with fake brew/mise) and `kriogenx release`.

### Changed
- Layout: `bin/` holds only commands; `kriogenx` code lives in
  `lib/kriogenx/`; installers in `libexec/install/`; aliases are split into
  `configs/rc/aliases/<topic>.sh`, loaded by `aliasesrc`; README moved to the
  repo root.
- `developer-essentials` installs dev tools only, without languages.
- `install.sh` runs `kriogenx` commands and needs a kriogenx checkout.
- `gbdm`, `gbdmd`, `gbdmc` list the branches and ask before deleting.
- `kriogenx version` prints the version from `VERSION` plus the commit.
- `kriogenx install <unknown>` now exits 1.
- `rinstall` / `rup` use mise when installed, else RVM.
- `create_link` uses `sudo` only for paths you can't write to.
- Make profile setup repeatable and share it with `pimp-my-shell`.

### Removed
- Per-language installers `ruby-install` (RVM), `node-install` (nvm),
  `python-install` (pyenv), `rust-install` (rustup), `go-install`; replaced
  by mise.
- `docker-install` command; use `kriogenx install docker`.
- Apache and MySQL: `kriogenx apache|mysql`, `bin/apache`, the `a*`/`my*`
  aliases and MySQL PATH entries.
- Janus vim plugins (abandoned; installed via `curl bit.ly | bash`).
- Composer self-update and RVM updates from `kriogenx update`.
- `dropbox-takeover` and `forter`.
- Dreamweaver and SVN entries in `.gitignore`.

### Fixed
- `gbdm` works in repos whose main branch is not `$GIT_MAIN_BRANCH` (e.g.
  `master`), and no longer chokes on `*`/`+` markers, detached HEAD, or
  branch names containing the main branch name.
- `create_link` exits on errors instead of continuing (top-level `return`
  is invalid in a script); prints usage and rejects a missing destination.
- `dccs` is now an alias (it was a bare variable assignment).
- `gcl` stops if the clone or `cd` fails.
- Quote file paths and preserve merge tool arguments throughout shell helpers.
- Treat message text as data in formatted output and fix prompt color escapes.
- Match legacy macOS versions correctly and avoid duplicate PATH entries.
