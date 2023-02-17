function set_macos_defaults() {
    # References
    # https://macos-defaults.com/
    # https://github.com/mathiasbynens/dotfiles/blob/main/.macos

    # Change keyboard speed
    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write NSGlobalDomain InitialKeyRepeat -int 10

    # Change keyboard settings
    # Use F1,F2 keys as standard
    defaults write -globalDomain com.apple.keyboard.fnState -boolean true

    # Disable press-and-hold for keys in favor of key repeat
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    # Change mouse/trackpad settings
    defaults write -globalDomain com.apple.trackpad.enableSecondaryClick -int 1
    defaults write -globalDomain com.apple.trackpad.fiveFingerPinchSwipeGesture -int 2
    defaults write -globalDomain com.apple.trackpad.fourFingerHorizSwipeGesture -int 2
    defaults write -globalDomain com.apple.trackpad.fourFingerPinchSwipeGesture -int 2
    defaults write -globalDomain com.apple.trackpad.fourFingerVertSwipeGesture -int 2
    defaults write -globalDomain com.apple.trackpad.momentumScroll -int 1
    defaults write -globalDomain com.apple.trackpad.pinchGesture -int 1
    defaults write -globalDomain com.apple.trackpad.rotateGesture -int 1
    defaults write -globalDomain com.apple.trackpad.scrollBehavior -int 2
    defaults write -globalDomain com.apple.trackpad.threeFingerDragGesture -int 0
    defaults write -globalDomain com.apple.trackpad.threeFingerHorizSwipeGesture -int 2
    defaults write -globalDomain com.apple.trackpad.threeFingerTapGesture -int 2
    defaults write -globalDomain com.apple.trackpad.threeFingerVertSwipeGesture -int 2
    defaults write -globalDomain com.apple.trackpad.twoFingerDoubleTapGesture -int 1
    defaults write -globalDomain com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture -int 3
    defaults write -globalDomain com.apple.trackpad.scaling 3
    # Trackpad: enable tap to click for this user and for the login screen
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    # Use list view in all Finder windows by default
    # Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Keep folders on top when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # Finder: show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Show hidden files
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Use scroll gesture with the Ctrl (^) modifier key to zoom
    defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
    defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

    # Show the ~/Library folder
    chflags nohidden ~/Library
    
    # Show the /Volumes folder
    chflags nohidden /Volumes

    # Sleep the display after 10 minutes
    sudo pmset -a displaysleep 10

    # Set machine sleep to 5 minutes on battery
    sudo pmset -b sleep 5

    # Set standby delay to 24 hours (default is 1 hour)
    sudo pmset -a standbydelay 86400

    # Require password immediately after sleep or screen saver begins
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0

    # Disable the sound effects on boot
    sudo nvram SystemAudioVolume=" "

    # Hotkeys
    # Focus to next window
    #defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 27 "{enabled = 1; value = { parameters = (186, 10, 1048576); type = 'standard'; }; }"

    # Hot corners
    # Possible values:
    #  0: no-op
    #  2: Mission Control
    #  3: Show application windows
    #  4: Desktop
    #  5: Start screen saver
    #  6: Disable screen saver
    #  7: Dashboard
    # 10: Put display to sleep
    # 11: Launchpad
    # 12: Notification Center
    # 13: Lock Screen
    # Top left screen corner → Desktop
    # tl-modifier 1048576 -> Cmd
    defaults write com.apple.dock wvous-tl-corner -int 4
    defaults write com.apple.dock wvous-tl-modifier -int 1048576
    # Top right screen corner → Start screen saver
    defaults write com.apple.dock wvous-tr-corner -int 5
    defaults write com.apple.dock wvous-tr-modifier -int 1048576
    # Bottom left screen corner → Lock screen
    defaults write com.apple.dock wvous-bl-corner -int 13
    defaults write com.apple.dock wvous-bl-modifier -int 1048576

    # Show Apple top bar
    defaults write NSGlobalDomain _HIHideMenuBar -bool false

    ###############################################################################
    # File Vault                                                                  #
    ###############################################################################

    # Enable vault
    defaults write com.apple.MCX.FileVault2 Enable -string yes


    ###############################################################################
    # Screenshots                                                                 #
    ###############################################################################

    # Set up directory to save screenshots inside ~/Downloads/screenshots.
    # I choose  this directory because download folder is my most reviewed dir
    mkdir -p ~/Downloads/screenshots
    defaults write com.apple.screencapture location ~/Downloads/screenshots

    # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
    defaults write com.apple.screencapture type -string "png"


    ###############################################################################
    # Dock                                                                        #
    ###############################################################################

    # Show in Dock just opened applications
    defaults write com.apple.dock static-only -bool true

    # Automatically hide and show the dock
    defaults write com.apple.dock autohide -bool true

    # Disable changes in the Dock
    defaults write com.apple.dock contents-inmutable -bool true

    # The size of the largest magnification. Min 16, Max 128
    defaults write com.apple.dock largesize -int 50
    defaults write com.apple.dock tilesize -int 50

    # orientation of the Dock. Values bottom, left and right
    defaults write com.apple.dock orientation -string bottom
    
    # Remove the Auto-Hide Dock delay
    defaults write com.apple.Dock autohide-delay -float 0

    # Disable earrange spaces automatically
    defaults write com.apple.dock "mru-spaces" -bool "false"

    # Apply all Dock settings
    killall Dock

    ###############################################################################
    # Spotify                                                                     #
    ###############################################################################

    # Does not run when start
    defaults write com.spotify.client AutoStartSettingIsHidden -int 0

}

#function change_caps_lock_to_control() {
#    VENDOR_ID=$1
#    PRODUCT_ID=$2
#
#    CAPS_LOCK_KEY_ID=30064771300
#    CONTROL_KEY_ID=30064771129
#
#    blue "Read current configuration of your keyboard"
#    defaults -currentHost read -g | grep -e "$VENDOR_ID-$PRODUCT_ID"
#    STATUS=$?
#    if [[ $STATUS == 0 ]];
#    then
#        green "This device is already configured"
#    else
#        blue "Change Caps Lock to Control in bluetooth keyboard"
#        defaults -currentHost write -g com.apple.keyboard.modifiermapping.$VENDOR_ID-$PRODUCT_ID-0 -array-add "<dict><key>HIDKeyboardModifierMappingDst</key><integer>$CAPS_LOCK_KEY_ID</integer><key>HIDKeyboardModifierMappingSrc</key><integer>$CONTROL_KEY_ID</integer></dict>"
#        red "========================================="
#        green "Success! This actions required restart"
#        red "========================================="
#    fi
#}
#
#function change_caplock_to_control_in_keyboards() {
#  #KEYBOARD_IO_NAMES=$(ioreg | grep '<class' | grep -i keyboard | awk -F'<class' '{ print $2}' | cut -d',' -f1 | sort -u)
#
#}

if test "$(uname)" = "Darwin"
then
    blue "Setting MacOS defaults"
    set_macos_defaults
    # change_caplock_to_control_in_keyboards
fi

