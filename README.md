Scripts
=======

Kriogenx Scripts v1.3

# Get Started #
```
curl http://scripts.kriogenx.net | bash
```

or

```
curl https://raw.githubusercontent.com/kriogenx0/scripts/master/curl-me.sh | bash
```

Make sure after installing your `.bashrc` and `.zshrc` both include
`.profile`.

# Packages #
Kriogenx Scripts are a series of packaged scripts that include developer installs, Mac OS X tweaks, and Dropbox goodies.

Once kriogenx scripts are installed, each command will be added to your
$PATH.

## Package Installer ##
The Package Installer offers running each package available. Running the
installer script will ask which packages you'd like to install.
```
curl https://raw.githubusercontent.com/kriogenx0/scripts/master/install.sh | bash
```

## Developer Setup ##

Developer Setup installs the following:
* Homebrew
* Git & Configures Git
* Tig (Tool for Git Logs)
* Janus (VIM Plugins)
* SSH & Configures SSH
* Fixes for GCC

```
developer-setup
```

## Pimp My Shell ##
Some scripts to get BASH or ZSH mighty fine looking.  This requires Kriogenx Scripts installed

```
pimp-my-shell
```

## Dropbox Sync ##
Dropbox Sync allows you to sync Application Preferences and Documents to multiple machines, similar to the way iCloud syncs bookmarks, documents, and photos. Applications and Global Settings supported are:
* Desktop Sync
* Hosts file
* iTunes
* Filezilla
* Photoshop
* Sequel Pro
* Adium
* Apache Configure and Vhosts
* Safari (in place of iCloud)

## K ##
K includes some valuable functions that make script development much easier.
* k - a simple way to see which services are running
* msg - a great way to send colorful and styled messages in BASH or ZSH
* make_alias - make some aliases instead of symlinks
* rails tools
* krepeat repeat a command over and over

## Aliases ##
Git
* ga - add all files
* go - git checkout
* glr - git pull rebase
* gpo - git push origin of current branch
* gol - git checkout last branch
* gbc - print current branch
* gmm - git merge master into current branch
* gigi - force ignore somefiles
* gfix - run diagnostics and prune

For all aliases, see the kriogenx rc file using:
```
krc
```
