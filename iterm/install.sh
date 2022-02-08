if test "$(uname)" = "Darwin"
then
    if [ -f ~/Library/Preferences/com.googlecode.iterm2.plist ];then
      TANGO_THEME=$(plutil -extract "Custom Color Presets" xml1 -o - ~/Library/Preferences/com.googlecode.iterm2.plist | grep 'Builtin Tango' | wc -l)

      if [ "${TANGO_THEME}" = "0" ];then
        # Install the Builtin Tango Dark theme for iTerm
        open "$HOME/.dotfiles/plugins/dotfiles-alberto-chamorro/iterm/theme/Builtin Tango Dark.itermcolors"
      fi
    fi

    defaults write com.googlecode.iterm2 PromptOnQuit -bool false
    defaults write com.googlecode.iterm2 SUEnableAutomaticChecks -int 1
    defaults write com.googlecode.iterm2 SUHasLaunchedBefore -int 1
    defaults write com.googlecode.iterm2 SUSendProfileInfo -int 0
    defaults write com.googlecode.iterm2 SoundForEsc -int 0
    defaults write com.googlecode.iterm2 StatusBarPosition -int 1
    defaults write com.googlecode.iterm2 TabStyleWithAutomaticOption -int 5
    defaults write com.googlecode.iterm2 TabViewType -int 2
    defaults write com.googlecode.iterm2 UseBorder -int 0
    defaults write com.googlecode.iterm2 HideScrollbar -int 1
    defaults write com.googlecode.iterm2 HideTab -int 1
fi