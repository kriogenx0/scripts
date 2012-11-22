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
    ln -s ~/Dropbox/Music/iTunes\ Library/iTunes\ Music/Books ~/Music/iTunes/iTunes\ Music
    ln -s ~/Dropbox/Music/iTunes\ Library/iTunes\ Music/Voice\ Memos ~/Music/iTunes/iTunes\ Music
    echo 'iTunes synced with dropbox'
  fi
else
  echo 'Already syncing iTunes'
fi

# Takeover Filezilla
if [ -e ~/.filezilla ]; then
  if [ ! -L ~/.filezilla ]; then
    if [ -d ~/Dropbox/Office/Filezilla ]; then
      mv ~/.filezilla ~/filezilla-old
      ln -s ~/Dropbox/Office/Filezilla ~/.filezilla
      echo 'Filezilla dropbox used'
    else
      mkdir -p ~/Dropbox/Office/Filezilla
      mv ~/.filezilla/* ~/Dropbox/Office/Filezilla/
      ln -s ~/Dropbox/Office/Filezilla ~/.filezilla
      echo 'Filezilla moved to dropbox'
    fi
  else
    echo 'Already syncing Filezilla'
  fi
else
  echo 'Filezilla not installed'
fi
