if [ ! -d ~/Dropbox ]; then
  echo 'Dropbox is required for this script'
  exit 0
fi
if [ ! -d ~/Dropbox/Office ]; then
  mkdir ~/Dropbox/Office
fi

if [ ! -d ~/Dropbox/Office/settings ]; then
  mkdir -p ~/Dropbox/Office/settings
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
    if [ -d ~/Dropbox/Office/settings/Filezilla ]; then
      mv ~/.filezilla ~/filezilla-old
      ln -s ~/Dropbox/Office/settings/Filezilla ~/.filezilla
      echo 'Filezilla dropbox used'
    else
      mkdir -p ~/Dropbox/Office/settings/Filezilla
      mv ~/.filezilla/* ~/Dropbox/Office/settings/Filezilla/
      ln -s ~/Dropbox/Office/settings/Filezilla ~/.filezilla
      echo 'Filezilla moved to dropbox'
    fi
  else
    echo 'Already syncing Filezilla'
  fi
else
  echo 'Filezilla not installed'
fi

# Takeover Filezilla Application
if [ ! -L /Applications/FileZilla.app ]; then
  if [ -d /Applications/FileZilla.app ]; then
    sudo mv /Applications/FileZilla{,-old}.app
  fi
  ln -s ~/Dropbox/Office/Applications/FileZilla.app /Applications/
fi

# Photoshop Settings
if [ ! -L ~/Library/Preferences/Adobe\ Photoshop\ CS6\ Settings ]; then
  if [[ -d /Applications/"Adobe Photoshop CS6" ]]; then
    if [ -d ~/Library/Preferences/Adobe\ Photoshop\ CS6\ Settings ]; then
      mv ~/Library/Preferences/Adobe\ Photoshop\ CS6\ Settings ~/Library/Preferences/Adobe\ Photoshop\ CS6\ Settings-old
    fi
    ln -s ~/Dropbox/Office/settings/photoshop/Adobe\ Photoshop\ CS6\ Settings ~/Library/Preferences/Adobe\ Photoshop\ CS6\ Settings
  fi
  echo 'Syncing Photoshop settings'
else
  echo 'Already syncing Photoshop'
fi

if [[ -e /Applications/"Adobe Photoshop CS6" ]]; then
  PS_V=CS6
elif [[ -e /Applications/"Adobe Photoshop CS5" ]]; then
  PS_V=CS5
fi

if [ -n $PS_V ]; then
  PS_FILES=("Actions Palette" Gradients.psp "Keyboard Shortcuts Primary.psp" "Keyboard Shortcuts.psp" )
  PS_PREFS=~/Library/Preferences/Adobe\ Photoshop\ ${PS_V}\ Settings/
  PS_PREFS_LENGTH=${#PS_PREFS[@]}

  # Moving Existing Workspaces
  DROPBOX_PS=~/Dropbox/Office/settings/photoshop/

  for $PS_F in $PS_FILES; do
    if [ -L  ]; then
      
    fi
  done

  if [ -d $DROPBOX_PS_WS ]; then
    mv ${PS_WS}/* ${DROPBOX_PS_WS}/
    rm -rf $PS_WS
    ln -s $DROPBOX_PS_WS $PS_WS
  fi
fi
