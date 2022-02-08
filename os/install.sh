function set_macos_defaults() {
    # Reference https://github.com/mathiasbynens/dotfiles/blob/main/.macos

    # Change keyboard speed
    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write NSGlobalDomain InitialKeyRepeat -int 10

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

    # Use scroll gesture with the Ctrl (^) modifier key to zoom
    defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
    defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

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
    defaults write com.apple.dock wvous-tl-corner -int 4
    defaults write com.apple.dock wvous-tl-modifier -int 0
    # Top right screen corner → Start screen saver
    defaults write com.apple.dock wvous-tr-corner -int 5
    defaults write com.apple.dock wvous-tr-modifier -int 0
    # Bottom left screen corner → Lock screen
    defaults write com.apple.dock wvous-bl-corner -int 13
    defaults write com.apple.dock wvous-bl-modifier -int 0
}

if test "$(uname)" = "Darwin"
then
    blue "Setting MacOS sane defaults"
    set_macos_defaults
    change_caplock_to_control_in_keyboards
fi