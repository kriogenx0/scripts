#!/bin/sh
git config --global apply.whitespace nowarn
git config --global merge.tool opendiff
#git config --global diff.tool twdiff
git config --global merge.prompt false
git config --global mergetool.keepBackup false
git config --global mergetool.keepTemporaries 'false'

# Colors
git config --global color.ui true
git config --global color.branch.current yellow reverse
git config --global color.branch.local yellow
git config --global color.branch.remote green
git config --global color.diff.meta yellow bold
git config --global color.diff.frag magenta bold
git config --global color.diff.old red bold
git config --global color.diff.new green bold
git config --global color.diff.white red reverse
git config --global color.status.added yellow
git config --global color.status.changed green
git config --global color.status.untracked cyan

### Difftools

# opendiff
git config --global diff.external ~/Sites/kriogenx/scripts/settings/opendiff-mergetool

# textwrangler
git config --global difftool.twdiff.cmd "twdiff --wait \"\$LOCAL\" \"\$REMOTE\""
#git config --global diff.external ~/git-twdiff.sh
git config --global diff.external ~/Sites/kriogenx/scripts/settings/textwrangler-mergetool

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
git config --global mergetool.p4.cmd 'p4merge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
git config --global mergetool.p4.keepTemporaries 'false'
git config --global mergetool.p4.trustExistCode 'false'

if [ -d "/Applications/Xcode.app/Contents" ]; then
  sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
fi
