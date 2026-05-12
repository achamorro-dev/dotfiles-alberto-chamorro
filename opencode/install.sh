OPENCODE_CONFIG_DIR=$HOME/.config/opencode
OPENCODE_DOTFILES_DIR=$HOME/.dotfiles/plugins/dotfiles-alberto-chamorro/opencode


if [ ! -d $OPENCODE_CONFIG_DIR ];then
    mkdir $OPENCODE_CONFIG_DIR
fi

ln -sf $OPENCODE_DOTFILES_DIR/config/* $OPENCODE_CONFIG_DIR

