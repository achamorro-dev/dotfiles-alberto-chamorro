if test "$(uname)" = "Darwin"
then
    # Install the Builtin Tango Dark theme for iTerm
    open "theme/Builtin Tango Dark.itermcolors"

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