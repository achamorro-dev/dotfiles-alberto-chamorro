WORKSPACE_DIR=$HOME/workspace

if [ ! -d $WORKSPACE_DIR ];then
    mkdir $WORKSPACE_DIR
fi

chmod go-w '/opt/homebrew/share'
chmod -R go-w '/opt/homebrew/share/zsh'

