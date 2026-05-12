CLAUDE_CONFIG_DIR=$HOME/.claude
CLAUDE_DOTFILES_DIR=$HOME/.dotfiles/plugins/dotfiles-alberto-chamorro/claude

if [ ! -d $CLAUDE_CONFIG_DIR ];then
    mkdir $CLAUDE_CONFIG_DIR
fi

ln -sf $CLAUDE_DOTFILES_DIR/config/* $CLAUDE_CONFIG_DIR

