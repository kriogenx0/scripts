OSX_VERSION=$(sw_vers | grep ProductVersion | awk -F: '{print $2}')

# MOUNTAIN LION
if [[ $OSX_VERSION =~ "10.8*" ]]; then

  # SCROLL DIRECTION
  defaults write ~/Library/Preferences/. GlobalPreferences com.apple.swipescrolldirection -bool false
  defaults write -g com.apple.swipescrolldirection -bool false

  # SPACES DELAY
  defaults write com.apple.dock workspaces-edge-delay -float 0.1

  # DISABLE ANIMATIONS
  #defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool NO
  defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

  # Mail Animations
  defaults write com.apple.Mail DisableReplyAnimations -bool YES
  defaults write com.apple.Mail DisableSendAnimations -bool YES

  # MISSION CONTROL ANIMATION
  defaults write com.apple.dock expose-animation-duration -int 0

  # LAUNCHPAD
  defaults write com.apple.dock springboard-show-duration -int 0
  defaults write com.apple.dock springboard-hide-duration -int 0

  # Change Default Save Location from icloud to local
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  # Disable Key Repeat
  defaults write -g ApplePressAndHoldEnabled -bool false

  # All Network Items including older Air Drop
  defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

  # Disable Rubberbanding
  defaults write -g NSScrollViewRubberbanding -int 0

  # Show Library Folder
  sudo chflags nohidden ~/Library
  chflags nohidden ~/Library

  # Dock Speed
  defaults write com.apple.dock autohide-time-modifier -int 0
  # defaults delete com.apple.dock autohide-time-modifier

elif [[ $OSX_VERSION =~ "10.7*" ]]; then
  # LION

  # Scroll Direction
  defaults write -g com.apple.swipescrolldirection -bool false

  # DESKTOP SHORTCUT
  defaults write NSGlobalDomain NSSavePanelStandardDesktopShortcutOnly -bool YES

  #DISABLE ANIMATIONS
  defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool NO
  #defaults write com.apple.Mail DisableReplyAnimations -bool YES
  #defaults write com.apple.Mail DisableSendAnimations -bool YES

  defaults write ~/Library/Preferences/. GlobalPreferences com.apple.swipescrolldirection -bool false

  # MISSION CONTROL ANIMATION
  defaults write com.apple.dock expose-animation-duration -int 0

  # LAUNCHPAD
  defaults write com.apple.dock springboard-show-duration -int 0
  defaults write com.apple.dock springboard-hide-duration -int 0

  defaults write -g ApplePressAndHoldEnabled -bool false

  # Change Default Save Location from icloud to local
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

elif [[ $OSX_VERSION =~ "10.6*" ]]; then
  # SNOW LEOPARD
  defaults write com.apple.dashboard mcx-disabled -boolean YES
fi

# Downloads
mkdir -p ~/Downloads/ScreenShots
defaults write com.apple.screencapture location ~/Downloads/ScreenShots

ln -s ~/Library/Containers/com.apple.mail/Data/Library/Mail\ Downloads ~/Downloads/

#####################
# ALL OS'S

# Disable All Animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Sheet Animations
defaults write NSGlobalDomain NSWindowResizeTime .001

# Disable Crash Reporting
defaults write com.apple.CrashReporter DialogType none

# Dock
defaults write com.apple.dock orientation right

# Extension Warning
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# DOCK MOUSE OVER DELAY
defaults write com.apple.Dock autohide-delay -float 0

# Disable "Are you sure you want to open this"
defaults write com.apple.LaunchServices LSQuarantine -bool NO


# Safari Bookmarks
defaults write com.apple.Safari ProxiesInBookmarksBar '("Reading List")'
#defaults write com.apple.Safari ProxiesInBookmarksBar '()'
#defaults write com.apple.Safari ProxiesInBookmarksBar '("Top Sites","Reading List)'

# Kill All Services
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -all local,system,user

killall SystemUIServer
killall Dock
killall Finder
