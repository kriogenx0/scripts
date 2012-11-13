#!/bin/sh

# White space
git config --global apply.whitespace nowarn
git config --global core.editor /usr/bin/vim

# Simple Push Default
git config --global push.default simple

# Colors
# OPTIONS ARE
# normal, black, red, green, yellow, blue, magenta, cyan and white
# bold, dim, ul, blink and reverse
# http://shallowsky.com/blog/programming/gitcolors.html
git config --global color.ui true
git config --global color.branch.plain normal
git config --global color.branch.current 'yellow reverse'
git config --global color.branch.local yellow
git config --global color.branch.remote green
git config --global color.diff.plain normal
git config --global color.diff.meta 'yellow bold'
git config --global color.diff.frag 'magenta bold'
git config --global color.diff.old 'red bold'
git config --global color.diff.new 'green bold'
git config --global color.diff.white 'red reverse'
git config --global color.diff.whitespace normal red
git config --global color.diff.commit yellow
git config --global color.status.header normal
git config --global color.status.added yellow
git config --global color.status.changed green
git config --global color.status.updated green
git config --global color.status.untracked cyan
git config --global color.status.nobranch red
git config --global color.grep.match green
git config --global color.interactive.prompt red
git config --global color.interactive.header normal
git config --global color.interactive.help green
git config --global color.interactive.error red

# Merge & Diff
git config --global merge.tool p4
git config --global merge.prompt false
git config --global mergetool.keepBackup false
git config --global mergetool.keepTemporaries 'false'
#git config --global diff.tool twdiff #options: opendiff diffmerge kdiff3 bbedit textwrangler
#git config --global diff.external p4diff

##############
### Difftools

# opendiff
git config --global difftool.opendiff.external ~/Sites/kriogenx/scripts/support/git/opendiff-mergetool

# diffmerge
git config --global difftool.diffmerge.cmd "diffmerge \$LOCAL \$REMOTE"

# kdiff3
if [[ -d "/Applications/kdiff.app/Contents" ]]; then
  git config --global difftool.kdiff3.path '/Applications/kdiff3.app/Contents/MacOS/kdiff3'
  git config --global difftool.kdiff3.trustExistCode 'false'
fi

# bbedit - install command line tools
git config --global difftool.bbedit.cmd "twdiff --wait \"\$LOCAL\" \"\$REMOTE\""
#bbdiff = !"sh -c \"if [ -f '$1' ] && [ -f '$2' ]; then bbdiff --wait --resume '$1' '$2' fi exit 0 \""

# textwrangler - install command line tools
git config --global difftool.twdiff.cmd "twdiff --wait \"\$LOCAL\" \"\$REMOTE\""
#git config --global diff.external ~/git-twdiff.sh
#git config --global diff.external ~/Sites/kriogenx/scripts/support/git/textwrangler-mergetool

##############
### Mergetools

# araxis
git config --global mergetool.araxis.cmd 'araxis-mergetool "$LOCAL" "$REMOTE" "$MERGED" "$BASE"'

# diffmerge
git config --global mergetool.diffmerge.cmd 'diffmerge --merge\n--result="$MERGED $LOCAL $BASE $REMOTE"'
git config --global mergetool.diffmerge.trustExistCode 'true'

# kdiff3
if [[ -d "/Applications/kdiff.app/Contents" ]]; then
  git config --global mergetool.kdiff3.path '/Applications/kdiff3.app/Contents/MacOS/kdiff3'
  git config --global mergetool.kdiff3.trustExistCode 'false'
fi

# p4merge
git config --global mergetool.p4.cmd '~/Sites/kriogenx/scripts/support/git/p4-mergetool "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
git config --global mergetool.p4.keepTemporaries 'false'
git config --global mergetool.p4.trustExistCode 'false'

# bbedit - install command line tools
git config --global mergetool.bbedit.cmd "bbdiff --wait \"\$LOCAL\" \"\$REMOTE\""

# textwrangler - install command line tools
git config --global mergetool.twdiff.cmd "twdiff --wait \"\$LOCAL\" \"\$REMOTE\""