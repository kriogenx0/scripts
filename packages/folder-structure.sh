# Show Library Folder
chflags nohidden ~/Library

if [ -d ~/Library/Containers/com.apple.mail/Data/Library/Mail\ Downloads ] && [ ! -L ~/Downloads/Mail\ Downloads ]; then
  ln -s ~/Library/Containers/com.apple.mail/Data/Library/Mail\ Downloads ~/Downloads/Mail\ Downloads
fi
