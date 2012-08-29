git config --global apply.whitespace nowarn
git config --global merge.tool opendiff
git config --global merge.prompt false
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

git config --global mergetool.araxis.cmd \
    'araxis-mergetool "$LOCAL" "$REMOTE" "$MERGED" "$BASE"'
git config --global merge.tool araxis

if [ -d /Applications/Xcode.app/Contents ]; then
  sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
fi
