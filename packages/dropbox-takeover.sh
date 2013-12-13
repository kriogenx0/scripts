# Settings
DRP_HOME=~/Dropbox
DRP_SETTINGS=${DRP_HOME}/Office/settings

#######

if [ ! -d $DRP_HOME ]; then
  echo 'Dropbox is required for this script'
  exit 0
fi

dropbox_takeover_help() {
  cat << EOF
a | all           All packages
d | desktop       Desktop
h | host Hosts file
i) iTunes

EOF
}

# Create Directories if they don't exist
mkdir -p $DRP_SETTINGS

# SSH
O_SSH=~/.ssh
DRP_SSH="$DRP_SETTINGS"/ssh

if [[ -L $O_SSH ]]; then
  sudo rm -rf $O_SSH
fi
if [[ `file ~/.ssh` =~ 'directory' ]]; then
  #if [[ -e "$DRP_HOME"/Office/settings/ssh ]]; then
  #  sudo mv ~/.ssh "$DRP_HOME"/Office/settings/ssh-old
  #fi
  if [[ -e "$DRP_HOME"/Office/settings/ssh ]]; then
    ln -s "$DRP_HOME"/Office/settings/ssh ~/.ssh
  fi
fi

# Desktop
O_DESKTOP=$HOME/Desktop

# Delete if already syncing but broken
[[ `file "$O_DESKTOP"` =~ 'broken' ]] && sudo rm -rf "$O_DESKTOP"

if [[ ! -L "$O_DESKTOP" ]]; then
  DRP_DESKTOP=${DRP_HOME}/Office/Desktop
  if [ -d $DRP_DESKTOP ]; then
    # Move contents if exist
    `sudo mv "$O_DESKTOP"/* ${DRP_DESKTOP}/` >> /dev/null
    sudo rm -rf $O_DESKTOP
  else
    # If doesnt exist, create and link
    sudo mv $O_DESKTOP $DRP_DESKTOP
  fi
  ln -s $DRP_DESKTOP "$O_DESKTOP"
  echo 'Desktop - Success!'
else
  echo 'Desktop - Already Syncing'
fi

# Hosts File
HOSTS_PATH=/etc/hosts
if [ ! -L $HOSTS_PATH ]; then
  DRP_HOSTS_PATH=${DRP_HOME}/Office/settings/hosts

  # If dropbox exists
  if [ -e $DRP_HOSTS_PATH ]; then
    sudo mv $HOSTS_PATH ${DRP_HOSTS_PATH}2
  else
    sudo mv $HOSTS_PATH ${DRP_HOSTS_PATH}
  fi
  sudo ln -s $DRP_HOSTS_PATH $HOSTS_PATH
  echo 'Hosts - Success!'
else
  echo 'Hosts - Already Syncing'
fi

# iTunes
if [ ! -L ~/Music/iTunes ]; then
  if [ -d ~/Music/iTunes ]; then
    echo "iTunes - Can't continue, iTunes folder exists ~/Music/iTunes"
  elif [ ! -d ~/Dropbox/Music ]; then
    echo "iTunes - Can't continue, no Dropox iTunes folder exists ~/Dropbox/Music/iTunes"
  else
    mkdir -p ~/Music/iTunes
    ITUNES_FILES=('Album Artwork' 'iTunes Library Extras.itdb' 'iTunes Library Genius.itdb' 'iTunes Library.itl' 'iTunes Library.xml' 'iTunes Music Library Backup.xml' 'iTunes Music Library.xml' 'Previous iTunes Libraries');
    ITUNES_LENGTH=${#ITUNES_FILES[@]}
    for ((i=0;i<$ITUNES_LENGTH;i++)); do
      if [ -L ~/Dropbox/Music/iTunes\ Library/"${ITUNES_FILES[$i]}" ]; then
        rm -rf ~/Dropbox/Music/iTunes\ Library/"${ITUNES_FILES[$i]}"
      fi
      ln -s ~/Dropbox/Music/iTunes\ Library/"${ITUNES_FILES[$i]}" ~/Music/iTunes
    done
    mkdir -p ~/Music/iTunes/iTunes\ Music
    ln -s ~/Dropbox/Music/iTunes\ Library/iTunes\ Music/Music ~/Music/iTunes/iTunes\ Music
    ln -s ~/Dropbox/Music/iTunes\ Library/iTunes\ Music/Books ~/Music/iTunes/iTunes\ Music
    ln -s ~/Dropbox/Music/iTunes\ Library/iTunes\ Music/Voice\ Memos ~/Music/iTunes/iTunes\ Music
    #if [ -f ~/Dropbox/Music/iTunes\ Library/iTunes\ Music/.iTunes\ Preferences.plist ]; then
    #  ln -s ~/Dropbox/Music/iTunes\ Library/iTunes\ Music/.iTunes\ Preferences.plist ~/Music/iTunes/iTunes\ Music
    #fi
    echo 'iTunes - Success!'
  fi
else
  echo 'iTunes - Already syncing'
fi

# Filezilla
if [ -e /Applications/FileZilla.app ]; then
  if [[ ! -e ~/.filezilla ]]; then
    ln -s ~/Dropbox/Office/settings/Filezilla ~/.filezilla
    echo 'Filezilla - Success!'
  elif [ ! -L ~/.filezilla ]; then
    if [ -d ~/Dropbox/Office/settings/Filezilla ]; then
      mv ~/.filezilla ~/filezilla-old
      ln -s ~/Dropbox/Office/settings/Filezilla ~/.filezilla
      echo 'Filezilla - Success!'
    else
      mkdir -p ~/Dropbox/Office/settings/Filezilla
      mv ~/.filezilla/* ~/Dropbox/Office/settings/Filezilla/
      ln -s ~/Dropbox/Office/settings/Filezilla ~/.filezilla
      echo 'Filezilla - moved to dropbox'
    fi
  else
    echo 'Filezilla - Already syncing'
  fi
else
  echo 'Filezilla - Not installed'
fi

# Photoshop Settings
#if [ ! -L ~/Library/Preferences/Adobe\ Photoshop\ CS6\ Settings ]; then
#  if [[ -d /Applications/"Adobe Photoshop CS6" ]]; then
#    if [ -d ~/Library/Preferences/Adobe\ Photoshop\ CS6\ Settings ]; then
#      mv ~/Library/Preferences/Adobe\ Photoshop\ CS6\ Settings ~/Library/Preferences/Adobe\ Photoshop\ CS6\ Settings-old
#    fi
#    ln -s ~/Dropbox/Office/settings/photoshop/Adobe\ Photoshop\ CS6\ Settings ~/Library/Preferences/Adobe\ Photoshop\ CS6\ Settings
#  fi
#  echo 'Syncing Photoshop settings'
#else
#  echo 'Already syncing Photoshop'
#fi

#      mv ${PS_F}/* ${DROPBOX_PS}/
#      rm -rf $PS_WS
#      ln -s $DROPBOX_PS_WS $PS_WS

if [[ -e /Applications/"Adobe Photoshop CS6" ]]; then
  PS_V=CS6
elif [[ -e /Applications/"Adobe Photoshop CS5" ]]; then
  PS_V=CS5
elif [[ -e /Applications/"Adobe Photoshop CS4" ]]; then
  PS_V=CS4
fi

if [[ -n $PS_V ]]; then
  #PS_FILES=("Actions Palette.psp" Gradients.psp "Keyboard Shortcuts Primary.psp" "Keyboard Shortcuts.psp" "Optimized Output Settings" Patterns.psp Swatches.psp WorkSpaces "WorkSpaces (Modified)"  )
  PS_FILES=("Actions Palette.psp" Gradients.psp "Keyboard Shortcuts Primary.psp" "Keyboard Shortcuts.psp" Patterns.psp Swatches.psp WorkSpaces "WorkSpaces (Modified)"  )
  PS_PREFS=~/Library/Preferences/Adobe\ Photoshop\ ${PS_V}\ Settings/
  PS_PREFS_LENGTH=${#PS_PREFS[@]}
  DROPBOX_PS=~/Dropbox/Office/settings/photoshop/preferences/

  for PS_F in "${PS_FILES[@]}"; do
    #echo "$PS_PREFS""$PS_F"
    if [ -e "$PS_PREFS""$PS_F" ] && [ ! -L "$PS_PREFS""$PS_F" ]; then
      if [ -e "$DROPBOX_PS""$PS_F" ]; then
        mv "$PS_PREFS""$PS_F" "$PS_PREFS""$PS_F"-old
      else
        mv "$PS_PREFS""$PS_F" "$DROPBOX_PS""$PS_F"
      fi
    else
      rm -rf "$PS_PREFS""$PS_F"
    fi
    ln -s "$DROPBOX_PS""$PS_F" "$PS_PREFS""$PS_F"
  done
  echo 'Photoshop - Success!'
fi

# Sequel Pro
if [[ -e /Applications/"Sequel Pro.app" ]]; then
  SQ_DROPBOX=~/Dropbox/Office/settings/sequelpro

  if [[ ! -e /Applications/"Sequel Pro.app"/Contents/Frameworks/BWToolkitFramework.framework ]]; then
    SQ_OLD=1
  fi

  if [[ -z $SQL_OLD ]]; then
    SQ_PREF=~/Library/"Application Support"/"Sequel Pro"
    SQ_DROPBOX_PREF=${SQ_DROPBOX}/"Sequel Pro"
  else
    SQ_PREF=~/Library/Preferences/com.google.code.sequel-pro.plist
    SQ_DROPBOX_PREF=${SQ_DROPBOX}/com.google.code.sequel-pro.plist
  fi

  [[ -d ${SQ_DROPBOX} ]] || mkdir -p ${SQ_DROPBOX}
  if [[ -L ${SQ_PREF} ]]; then
    sudo rm -rf ${SQ_PREF}
    #echo "Sequel Pro - removed link"
    SQ_RECREATED=1
  fi

  # Move Current Prefs if Exist
  if [[ -f ${SQ_DROPBOX_PREF} ]]; then
    if [[ -e ${SQ_PREF} ]]; then
      sudo mv ${SQ_PREF} ${SQ_DROPBOX_PREF}"-old"
    #else
      #sudo mv ${SQ_PREF} ${SQ_DROPBOX_PREF}
    fi
  else
    if [[ -f ${SQ_PREF} ]]; then
      sudo mv ${SQ_PREF} ${SQ_DROPBOX_PREF}
    fi
  fi

  # Create Link
  if [[ -e "${SQ_DROPBOX_PREF}" ]] && [[ ! -L "${SQ_PREF}" ]]; then
    ln -s "${SQ_DROPBOX_PREF}" "${SQ_PREF}"
    if [[ -n $SQ_RECREATED ]]; then
      echo "Sequel Pro - Link recreated"
    else
      echo 'Sequel Pro - Success!'
    fi
  fi
fi

# Adium
if [[ -e /Applications/Adium.app ]]; then
  adium_dir=~/Library/Application\ Support/"Adium 2.0"/Users/Default
  adium_dropbox=~/Dropbox/Office/settings/adium/Default

  mkdir -p "$adium_dir"

  if [[ -L "$adium_dir"/Accounts.plist ]]; then
    echo 'Adium - Already syncing'
  else
    if [[ -d "$adium_dir" ]]; then
      sudo mv "$adium_dir" "$adium_dropbox"-old
      mkdir -p "$adium_dir"
    fi

    ADIUM_FILES=("$adium_dir"/*)
    #ADIUM_FILES=(Accounts.plist Confirmations.plist "Contact Alerts.plist" "Contact List Display.plist" "Detached Groups.plist" "Display Format.plist" "Events Preset.plist" General.plist libpurple/accounts.xml libpurple/certificates libpurple/logs libpurple/prefs.xml libpurple/xmpp-caps.xml Logging.plist Logs "Message Context Display.plist" otr.fingerprints OTR.plist otr.private_key "Saved Status.plist" Sorting.plist "Status Preferences.plist" "URL Handling Group.plist")

    for f in "${ADIUM_FILES[@]}"; do
      if [[ ! "$f" == *ByObjectPrefs* ]]; then
        #echo $f' synced'
        ln -s "$f" "$adium_dir"/
      fi
    done
    echo 'Adium - Success!'
  fi
fi

# Apache Takeover
if ! grep -q `whoami`'/Dropbox' /private/etc/apache2/httpd.conf; then
  APACHE_SITES="/Users/"`whoami`"/Dropbox/Office/settings/apache/sites.conf"
  echo "\n# Load Dropbox Sites" | sudo tee -a /private/etc/apache2/httpd.conf
  echo "Include ${APACHE_SITES}" | sudo tee -a /private/etc/apache2/httpd.conf

  if [[ ! -f "$APACHE_SITES" ]]; then
    echo '################\n# Add sites here\n' | sudo tee -a "$APACHE_SITES"
  fi
  echo 'Apache - Success!'
else
  echo 'Apache - Already syncing'
fi

# Safari
safari_dir=~/Library/Safari/
safari_dropbox=~/Dropbox/Office/settings/safari/
if [[ -d "$safari_dir" && -d "$safari_dropbox" ]]; then

  [[ -L "$safari_dir" ]] && sudo rm -f "$safari_dir"

  [[ -d "$safari_dir" ]] && sudo mv "$safari_dir" "$safari_dropbox"-old

  ln -s "$safari_dropbox" ~/Library/

#  safari_preferences=(Bookmarks.plist Downloads.plist Extensions History.plist)
#  for safari_pref in "${safari_preferences[@]}"; do
#    safari_pref_file="$safari_dir""$safari_pref"
#    safari_dropbox_pref_file="$safari_dropbox""$safari_pref"
#
#    # Delete Link if exists
#    [[ -L "$safari_pref_file" ]] && rm -rf "$safari_pref_file"
#
#    if [ -e "$safari_pref_file" ];  then
#      if [ -e "$safari_dropbox_pref_file" ]; then
#        mv "$safari_pref_file" "$safari_dropbox_pref_file"-old
#      else
#        mv "$safari_pref_file" "$safari_dropbox_pref_file"
#      fi
#      ln -s "$safari_dropbox_pref_file" "$safari_dir"
#    else
#      # If Safari Pref does not exist and dropbox does
#      if [ -e "$safari_dropbox_pref_file" ]; then
#        ln -s "$safari_dropbox_pref_file" "$safari_dir"
#      fi
#    fi
#  done
  echo "Safari - Ran"
fi

