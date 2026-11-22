Scripts
=======

Kriogenx Scripts: dotfiles, aliases and setup tools for a nicer macOS terminal.
See [`VERSION`](VERSION) and the [changelog](CHANGELOG.md); check the installed
version with `kriogenx version`.

# Get Started #

```
curl https://raw.githubusercontent.com/kriogenx0/scripts/master/curl-me.sh | bash
```

This clones kriogenx to `~/.kriogenx`, adds its `bin/` to your `$PATH`, and
makes `.bashrc` and `.zshrc` load `.profile`. Then pick what to install:

```
bash ~/.kriogenx/install.sh
```

The package installer asks about each package: developer essentials, Pimp My
Shell, Pimp My Git, languages and macOS hacks.

# Layout #

```
bin/                  commands on your PATH (kriogenx, create_link, hosts, msg, pimp-my-*, …)
lib/kriogenx/         code behind each kriogenx subcommand (install, services, update, …)
libexec/install/      installers, run through `kriogenx install <what>`
configs/rc/           shell setup: bashrc, aliasesrc (loader), aliases/<topic>.sh
configs/git/          git config, ignore file and merge tools
scripts/check         lint + tests (what CI runs)
test/                 bats tests
```

# kriogenx #

`kriogenx` (or `kk`) is the main entry point. Run `kriogenx help` for everything.

## Developer Essentials ##

```
kriogenx install essentials   # or: developer-essentials
```

Installs Xcode Command Line Tools and Homebrew, then offers git, tig, Docker +
Colima and an SSH key. Language toolchains are separate (see below).
`kriogenx install all` runs essentials, then languages.

## Languages ##

All languages are managed by [mise](https://mise.jdx.dev), which is installed
on first use:

```
kriogenx install ruby          # or node / python / rust / go
kriogenx install languages     # asks about each one
```

* Installs globally with `mise use --global`: latest by default, LTS for Node.
* Pick a version with `KRIO_<LANG>_VERSION`, e.g. `KRIO_NODE_VERSION=22 kriogenx install node`.
* Projects can still pin versions with `.tool-versions`, `.ruby-version`, `.nvmrc` or `mise.toml`.
* `bashrc` activates mise automatically. Existing RVM/nvm installs keep loading too.
* `kriogenx update` upgrades them.

## Docker ##

Installs the Docker CLI with Colima as the container runtime (no Docker Desktop):
docker, docker compose, docker buildx, docker-credential-helper and colima.

```
kriogenx install docker
```

Options, set as environment variables:
* `COLIMA_ARGS="--cpu 4 --memory 8"`: arguments for `colima start`
* `DOCKER_EXTRAS="lazydocker dive"`: extra Homebrew formulae to install

To start Colima at login, run `brew services start colima`.

## Services ##

`kriogenx nginx|postgres|redis <start|stop|status>`, e.g. `kk nginx s`.

## Shell & Git setup ##

* `pimp-my-shell`: oh-my-zsh plus the kriogenx theme
* `pimp-my-git`: git user, colors and merge/diff tools
* `macos-hacks`: macOS system tweaks

# Command Line Helpers #
* `create_link <source> <destination>`: move a file or folder and leave a symlink in its place (asks how to merge if both exist)
* `hosts`: view and edit `/etc/hosts`
* `msg`: colorful, styled messages in bash or zsh
* `make_alias`: make Finder aliases instead of symlinks
* `krepeat`: repeat a command over and over

# Aliases #

Aliases are split by topic in `configs/rc/aliases/`: core, git, apps, python,
ruby, node, services, docker, k8s, system and kriogenx.

* `aliasrc <topic>`: edit a topic and reload it (`aliasrc` alone lists the topics)
* `export KRIOGENX_SKIP_ALIASES="k8s ruby"`: skip topics you don't use (put it in `~/.profile` before kriogenx loads)
* `krc`: edit the main bashrc

Git highlights:
* ga - add all files
* go - git checkout
* glr - git pull rebase
* gpo - git push origin of current branch
* gol - git checkout last branch
* gbc - print current branch
* gmm - git merge `$GIT_MAIN_BRANCH` into the current branch
* gbdm - delete local branches merged into the main branch (asks first; `-y` skips)
* gcl `<owner/repo>` `[host]` - clone (GitHub by default) and cd into it
* gigi - force ignore some files
* gfix - run diagnostics and prune

# Releasing #
Versions follow semver. `VERSION` holds the current version and each release is tagged `vX.Y.Z`.
1. Add a `## [X.Y.Z]` section to `CHANGELOG.md`.
2. Run `kriogenx release <major|minor|patch>`. This commits `VERSION` and `CHANGELOG.md` and creates the tag.
3. Run `git push origin HEAD --follow-tags`.

# Development #

Install Bash, Zsh, ShellCheck and Bats, then run:

```sh
./scripts/check
```

This checks shell syntax, runs ShellCheck on every script, library, rc file
and alias topic, and runs the bats tests. CI runs the same command.

The installer tests use fake `brew`, `mise`, `colima` and `docker` commands,
so they never install anything. `create_link` only uses `sudo` for paths you
can't write to, so its tests run in temp directories. macOS tweaks
(`macos-hacks`) and app-specific merge tools are only lint-checked.
