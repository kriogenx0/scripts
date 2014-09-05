# Settings
DROP_HOME=~/Dropbox
DROP_SETTINGS=${DROP_HOME}/Office/settings

# TODO:
# GET -f param to recreate links

#######

if [ ! -d $DROP_HOME ]; then
  echo 'Dropbox is required for this script'
  exit 0
fi

create_link() {
  S="$1"
  D="$2"
  DD=
  # Duplicate Directory
  [[ -n $3 ]] && DD="$3" || DD="$D"-old-`date "+%Y-%m-%d"`

  # Remove If Link
  [[ -L "$S" ]] && rm -rf "$S"

  # Make Dir
  mkdir -p `dirname "$D"`

  # Rename Files if Exist
  if [[ -e "$S" ]]; then
    # If drop exists
    if [[ -e "$D" ]]; then
      mv "$S" "$DD"
    # If no drop exists
    else
      mv "$S" "$D"
    fi
  else
    if [[ ! -e "$D" ]]; then
      echo "Neither of locations exist:"
      echo "Source: $S"
      echo "Destination: $D"
      return 0
    fi
  fi

  # Create Links
  ln -s "$D" "$S"
}

dropbox_takeover_help() {
  cat << EOF
a | all           All packages
d | desktop       Desktop
h | host Hosts file
i) iTunes

EOF
}

# Create Directories if they don't exist
mkdir -p $DROP_SETTINGS

#################################

# SSH
SSH_PATH=~/.ssh
SSH_DROP="$DROP_SETTINGS"/ssh

if [[ -L $SSH_PATH ]]; then
  read -p "SSH - Already syncing.  Recreate link? y|n " SSH_SYNC
  case $SSH_SYNC in
    Y|y|yes)
      sudo rm -rf $SSH_PATH
  esac
elif [[ ! -d $SSH_DROP ]]; then
  read -p "SSH - Move .ssh to Dropbox? y|n " SSH_SYNC
else
  SSH_SYNC=y
fi

case $SSH_SYNC in
  Y|y|yes)
    [[ -e $SSH_PATH ]] && sudo mv $SSH_PATH "$SSH_DROP"-old-`date "+%Y-%m-%d"`
    mkdir -p "$SSH_DROP"
    ln -s "$SSH_DROP" $SSH_PATH
esac

#################################

# Desktop
DESK_PATH=$HOME/Desktop
DESK_DROP="$DROP_SETTINGS"/Desktop

# Delete if already syncing but broken
[[ `file "$DESK_PATH"` =~ 'broken' ]] && sudo rm -rf "$DESK_PATH"

if [[ ! -L "$DESK_PATH" ]]; then
  if [ -d $DESK_DROP ]; then
    # Move contents if exist
    `sudo mv "$DESK_PATH"/* ${DESK_DROP}/` >> /dev/null
    sudo rm -rf $DESK_PATH
  else
    # If doesnt exist, create and link
    sudo mv $DESK_PATH $DESK_DROP
  fi
  ln -s $DESK_DROP "$DESK_PATH"
  echo 'Desktop - Success!'
else
  echo 'Desktop - Already Syncing'
fi

#################################

# Documents
DOC_PATH=$HOME/Documents
DOC_DROP="$DROP_SETTINGS"/Documents

# Delete if already syncing but broken
[[ `file "$DOC_PATH"` =~ 'broken' ]] && sudo rm -rf "$DOC_PATH"

if [[ ! -L "$DOC_PATH" ]]; then
  if [ -d $DOC_DROP ]; then
    # Move contents if exist
    `sudo mv "$DOC_PATH"/* ${DOC_DROP}/` >> /dev/null
    sudo rm -rf $DOC_PATH
  else
    # If doesnt exist, create and link
    sudo mv $DOC_PATH $DOC_DROP
  fi
  ln -s $DOC_DROP "$DOC_PATH"
  echo 'Documents - Success!'
else
  echo 'Documents - Already Syncing'
fi

#################################

# Hosts File
HOSTS_PATH=/etc/hosts
HOSTS_DROP=${DROP_SETTINGS}/hosts

if [ ! -L $HOSTS_PATH ]; then

  # If dropbox exists
  if [ -e $HOSTS_DROP ]; then
    sudo mv $HOSTS_PATH ${HOSTS_DROP}-old-`date "+%Y-%m-%d"`
  else
    sudo mv $HOSTS_PATH ${HOSTS_DROP}
  fi
  sudo ln -s $HOSTS_DROP $HOSTS_PATH
  echo 'Hosts - Success!'
else
  echo 'Hosts - Already Syncing'
fi

#################################

# iTunes
ITUNES_PATH=~/Music/iTunes
ITUNES_FILES=('Album Artwork' 'iTunes Library Extras.itdb' 'iTunes Library Genius.itdb' 'iTunes Library.itl' 'iTunes Library.xml' 'iTunes Music Library Backup.xml' 'iTunes Music Library.xml' 'Previous iTunes Libraries');
ITUNES_LENGTH=${#ITUNES_FILES[@]}

if [ ! -L ~/Music/iTunes ]; then
  if [ -d ~/Music/iTunes ]; then
    echo "iTunes - No iTunes folder found at ~/Music/iTunes"
  elif [ ! -d ~/Dropbox/Music ]; then
    echo "iTunes - Can't continue, no Dropox iTunes folder exists ~/Dropbox/Music/iTunes"
  else
    mkdir -p ~/Music/iTunes
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

#################################

# Filezilla
FZ_APP=/Applications/FileZilla.app
FZ_PATH=~/.filezilla
FZ_DROP="$DROP_SETTINGS"/Filezilla

if [ -e $FZ_APP ]; then
  if [[ ! -e $FZ_PATH ]]; then
    ln -s $FZ_DROP $FZ_PATH
    echo 'Filezilla - Success!'
  elif [ ! -L $FZ_PATH ]; then
    if [ -d $FZ_DROP ]; then
      mv $FZ_PATH $FZ_PATH-old-`date "+%Y-%m-%d"`
      ln -s $FZ_DROP $FZ_PATH
      echo 'Filezilla - Success!'
    else
      mkdir -p $FZ_DROP
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

#################################
# Cyberduck

CYBERDUCK_DROP=~/Dropbox/Office/settings/Cyberduck
CYBERDUCK_LIB=~/Library/Application\ Support/Cyberduck

if [[ ! -e $CYBERDUCK_DROP ]]; then
  if [[ -e "$CYBERDUCK_LIB" ]]; then
    sudo mv "$CYBERDUCK_LIB" "$CYBERDUCK_DROP"
  else
    mkdir -p "$CYBERDUCK_DROP"
    ln -s "$CYBERDUCK_DROP" "$CYBERDUCK_LIB"
  fi
else
  if [[ -e "$CYBERDUCK_LIB" ]]; then
    sudo mv "$CYBERDUCK_LIB" "$CYBERDUCK_DROP"-`date "+%Y-%m-%d"`
  else
    ln -s "$CYBERDUCK_DROP" "$CYBERDUCK_LIB"
  fi
fi

defaults write ch.sudo.cyberduck application.support.path "$CYBERDUCK_DROP"


#################################

# Photoshop Settings
if [[ -e /Applications/Adobe\ Photoshop\ CC ]]; then
  PS_V=CC
elif [[ -e /Applications/Adobe\ Photoshop\ CS6 ]]; then
  PS_V=CS6
elif [[ -e /Applications/Adobe\ Photoshop\ CS5 ]]; then
  PS_V=CS5
elif [[ -e /Applications/Adobe\ Photoshop\ CS4 ]]; then
  PS_V=CS4
fi

if [[ -n $PS_V ]]; then
  echo "Photoshop - Syncing"

  PS_FILES=("Actions Palette.psp" Brushes.psp Gradients.psp "Keyboard Shortcuts Primary.psp" "Keyboard Shortcuts.psp" "Menu Customization.psp" Patterns.psp Swatches.psp "Workspace Prefs.psp" WorkSpaces "WorkSpaces (Modified)"  )
  PS_PREFS=~/Library/Preferences/Adobe\ Photoshop\ "$PS_V"\ Settings/
  PS_PREFS_LENGTH=${#PS_PREFS[@]}
  PS_DROP=$DROP_SETTINGS/photoshop/Adobe\ Photoshop\ "$PS_V"\ Settings/

  mkdir -p $PS_DROP

  for PS_F in "${PS_FILES[@]}"; do
    f="$PS_PREFS""$PS_F"
    df="$PS_DROP""$PS_F"

    [[ -L "$f" ]] && rm -rf "$f"

    # If Dropbox File exists
    if [[ -e "$df" ]]; then

      # If Preference Exists
      if [[ -e "$f" ]]; then
        mv "$f" "$f"-old-`date "+%Y-%m-%d"`
      fi

    # If Dropbox File does not exist
    else
      # Move to Dropbox
      [[ -e "$f" ]] && mv "$f" "$df"
    fi

    # LINK DROPBOX
    [[ -e "$df" ]] && ln -s "$df" "$f"
    #echo "--- $df \n--> $f"

  done
  echo 'Photoshop - Success!'
fi

#################################

# Sequel Pro
SQ_APP=/Applications/"Sequel Pro.app"

if [[ -e "$SQ_APP" ]]; then
  SQ_DROPBOX=~/Dropbox/Office/settings/sequelpro

  if [[ ! -e "$SQ_APP"/Contents/Frameworks/BWToolkitFramework.framework ]]; then
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
      sudo mv ${SQ_PREF} ${SQ_DROPBOX_PREF}-old-`date "+%Y-%m-%d"`
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

#################################

# Adium
ADIUM_APP=/Applications/Adium.app

if [[ -e $ADIUM_APP ]]; then
  ADIUM_PREF=~/Library/Application\ Support/"Adium 2.0"/Users/Default
  ADIUM_DROP="$DROP_SETTINGS"/adium/Default
  #ADIUM_FILES=(Accounts.plist Confirmations.plist "Contact Alerts.plist" "Contact List Display.plist" "Detached Groups.plist" "Display Format.plist" "Event Presets.plist" General.plist libpurple/accounts.xml libpurple/certificates libpurple/logs libpurple/prefs.xml libpurple/xmpp-caps.xml Logging.plist Logs "Message Context Display.plist" otr.fingerprints OTR.plist otr.private_key "Saved Status.plist" Sorting.plist "Status Preferences.plist" "URL Handling Group.plist")
  ADIUM_FILES=(Accounts.plist Confirmations.plist "Contact Alerts.plist" "Contact List Display.plist" "Detached Groups.plist" "Display Format.plist" "Event Presets.plist" General.plist libpurple Logging.plist Logs "Message Context Display.plist" otr.fingerprints OTR.plist otr.private_key "Saved Status.plist" Sorting.plist "Status Preferences.plist" "URL Handling Group.plist")

  mkdir -p "$ADIUM_PREF"

  if [[ -L "$ADIUM_PREF"/Accounts.plist ]]; then
    read -p "Adium - Already syncing.  Recreate link? y|n " ADIUM_SYNC
    #case $SSH_SYNC in
    #  Y|y|yes)
        #sudo rm -rf $ADIUM_PREF
    #esac
  else
    ADIUM_SYNC=y
  fi

  # ACTION
  case $ADIUM_SYNC in
    Y|y|yes)
      for pref in "${ADIUM_FILES[@]}"; do
        if [[ "$pref" == *ByObjectPrefs* ]]; then
          continue
        fi

        f="$ADIUM_PREF"/"$pref"

        # Remove if alias
        if [[ -L $f ]]; then
          rm -rf "$f"
        #elif [[ -e $f ]]; then
        #  [[ -e "$f"-old ]] && rm -rf "$f"-old
        #  mv "$f" "$f"-old
        fi

        # Create alias
        [[ -e "$ADIUM_DROP" ]] && ln -s "$ADIUM_DROP"/"$pref" "$ADIUM_PREF"/"$pref"

      done
      echo 'Adium - Success!'
      ;;
    *)
      echo 'Adium - Cancelled'
      ;;
  esac

fi

#################################

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

#################################

# Safari
#read -p 'Sync Safari? y/n ' safari

#case $safari in
#  Y|y|yes)
#
#    safari_dir=~/Library/Safari/
#    safari_dropbox=~/Dropbox/Office/settings/safari/
#    if [[ -d "$safari_dir" && -d "$safari_dropbox" ]]; then
#
#      [[ -L "$safari_dir" ]] && sudo rm -f "$safari_dir"
#
#      [[ -d "$safari_dir" ]] && sudo mv "$safari_dir" "$safari_dropbox"-old
#
#      ln -s "$safari_dropbox" ~/Library/
#
#      #  safari_preferences=(Bookmarks.plist Downloads.plist Extensions History.plist)
#      #  for safari_pref in "${safari_preferences[@]}"; do
#      #    safari_pref_file="$safari_dir""$safari_pref"
#      #    safari_dropbox_pref_file="$safari_dropbox""$safari_pref"
#      #
#      #    # Delete Link if exists
#      #    [[ -L "$safari_pref_file" ]] && rm -rf "$safari_pref_file"
#      #
#      #    if [ -e "$safari_pref_file" ];  then
#      #      if [ -e "$safari_dropbox_pref_file" ]; then
#      #        mv "$safari_pref_file" "$safari_dropbox_pref_file"-old
#      #      else
#      #        mv "$safari_pref_file" "$safari_dropbox_pref_file"
#      #      fi
#      #      ln -s "$safari_dropbox_pref_file" "$safari_dir"
#      #    else
#      #      # If Safari Pref does not exist and dropbox does
#      #      if [ -e "$safari_dropbox_pref_file" ]; then
#      #        ln -s "$safari_dropbox_pref_file" "$safari_dir"
#      #      fi
#      #    fi
#      #  done
#      echo "Safari - Ran"
#    fi
#esac

