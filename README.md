Scripts
=======

Kriogenx Scripts v1.2

# Get Started #
curl http://scripts.kriogenx.net | sh

or

curl https://raw.githubusercontent.com/kriogenx0/scripts/master/curl-me.sh | sh

# Packages #
Kriogenx Scripts are a series of packaged scripts that include developer installs, Mac OS X tweaks, and Dropbox goodies.

## Developer Essentials ##
It's installing a series of essential tools:
* Homebrew
* Git
* Tig (Tool for Git Logs)
* OH MY ZSH
* Janus (VIM Plugins)
* Kriogenx Scripts
* Fixes for GCC

To Install, Simply run:
curl https://raw.githubusercontent.com/kriogenx0/scripts/master/bin/developer-essentials.sh | sh

## Pimp My Shell ##
Some scripts to get BASH or ZSH mighty fine looking.  This requires Kriogenx Scripts installed

sh ~/Sites/kriogenx/scripts/bin/pimp-my-shell.sh

## Dropbox Sync ##
Dropbox Sync allows you to sync Application Preferences and Documents to multiple machines, similar to the way iCloud syncs bookmarks, documents, and images.  Applications and Global Settings supported are:
* Desktop Sync
* Hosts file
* iTunes
* Filezilla
* Photoshop
* Sequel Pro
* Adium
* Apache Configure and Vhosts
* Safari (in place of iCloud)

## Tools ##
Kriogenx includes some valuable functions that make script development
much easier.
* k - a simple way to see which services are running
* msg - a great way to send colorful and styled messages in BASH or ZSH
* make_alias - make some aliases instead of symlinks
* rails tools
* krepeat repeat a command over and over

## Git Tools ##
Git functions and aliases for everything. Type alias see to some magic
* ga - add all files
* go - git checkout
* glr - git pull
* gpo - git push origin of current branch
* gbc - print current branch
* gmm - git merge master in
* gigi - force ignore somefiles
* gfix - run diagnostics and prune

