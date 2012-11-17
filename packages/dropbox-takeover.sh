if [ ! -d ~/Dropbox ]; then
  echo 'Dropbox is required for this script'
  exit 0
fi
if [ ! -d ~/Dropbox/Office ]; then
  mkdir ~/Dropbox/Office
fi

# Takeover Desktop
if [ ! -L ~/Desktop ]; then
  if [ -d ~/Dropbox/Office/Desktop ]; then
    # If exists, move contents
    sudo mv ~/Desktop/* ~/Dropbox/Office/Desktop/
    sudo rm -rf ~/Desktop
  else
    # If doesnt exist, create and link
    sudo mv ~/Desktop ~/Dropbox/Office/Desktop
  fi
  ln -s ~/Dropbox/Office/Desktop ~/Desktop
else
  echo 'Already syncing Desktop'
fi

# Takeover iTunes
if [ ! -L ~/Music/iTunes ]; then
  if [ -d ~/Music/iTunes ]; then
    echo "Can't continue, iTunes folder exists ~/Music/iTunes"
  elif [ ! -d ~/Dropbox/Music ]; then
    echo "Can't continue, no Dropox iTunes folder exists ~/Dropbox/Music/iTunes"
  else
    mkdir -p ~/Music/iTunes
    ITUNES_FILES=('Album Artwork' 'iTunes Library Extras.itdb' 'iTunes Library Genius.itdb' 'iTunes Library.itl' 'iTunes Library.xml' 'iTunes Music Library Backup.xml' 'iTunes Music Library.xml' 'Previous iTunes Libraries');
    ITUNES_LENGTH=${#ITUNES_FILES[@]}
    for ((i=0;i<$ITUNES_LENGTH;i++)); do
      ln -s ~/Dropbox/Music/iTunes\ Library/"${ITUNES_FILES[$i]}" ~/Music/iTunes
    done
    mkdir -p ~/Music/iTunes/iTunes\ Music
    ln -s ~/Dropbox/Music/iTunes\ Library/iTunes\ Music/Music ~/Music/iTunes/iTunes\ Music
  fi
else
  echo 'Already syncing iTunes'
fi
