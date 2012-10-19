OSX_VERSION=$(sw_vers | grep ProductVersion | awk -F: '{print $2}')

# MOUNTAIN LION
if [[ $OSX_VERSION =~ "10.8*" ]]; then

  # SCROLL DIRECTION
  defaults write ~/Library/Preferences/. GlobalPreferences com.apple.swipescrolldirection -bool false

  # SPACES DELAY
  defaults write com.apple.dock workspaces-edge-delay -float 0.1

  # DISABLE ANIMATIONS
  defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool NO
  defaults write com.apple.Mail DisableReplyAnimations -bool YES
  defaults write com.apple.Mail DisableSendAnimations -bool YES

  # MISSION CONTROL ANIMATION
  defaults write com.apple.dock expose-animation-duration -int 0

  # LAUNCHPAD
  defaults write com.apple.dock springboard-show-duration -int 0
  defaults write com.apple.dock springboard-hide-duration -int 0

  defaults write -g ApplePressAndHoldEnabled -bool false

elif [[ $OSX_VERSION =~ "10.7*" ]]; then
# LION

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
defaults write com.apple.dock springboard-show-duration -int 0 defaults write com.apple.dock springboard-hide-duration -int 0

defaults write -g ApplePressAndHoldEnabled -bool false


elif [[ $OSX_VERSION =~ "10.6*" ]]; then
# SNOW LEOPARD
defaults write com.apple.dashboard mcx-disabled -boolean YES

fi

#####################
# ALL OS'S

# Disable Crash Reporting
defaults write com.apple.CrashReporter DialogType none

# Dock
defaults write com.apple.dock orientation right

defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# DOCK MOUSE OVER DELAY
defaults write com.apple.Dock autohide-delay -float 0


# Safari Bookmarks
defaults write com.apple.Safari ProxiesInBookmarksBar '("Reading List")'
#defaults write com.apple.Safari ProxiesInBookmarksBar '()'
#defaults write com.apple.Safari ProxiesInBookmarksBar '("Top Sites","Reading List)'

killall Dock
killall Finder
