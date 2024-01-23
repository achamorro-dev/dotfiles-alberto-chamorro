# Copy nvim config
rm -rf ~/.config/nvim
ln -s ~/.dotfiles/plugins/dotfiles-alberto-chamorro/nvim/config/nvim ~/.config/nvim

# Install vscode-chrome-debug
mkdir -p $HOME/.debuggers

CHROME_DEBUGGER_PATH=$HOME/.debuggers/vscode-chrome-debug
if [ ! -d $CHROME_DEBUGGER_PATH ];then
  git clone https://github.com/Microsoft/vscode-chrome-debug $CHROME_DEBUGGER_PATH

  cd $CHROME_DEBUGGER_PATH &&
  npm install &&
  npm run build &&
  cd -
fi

NODE_DEBUGGER_PATH=$HOME/.debuggers/vscode-js-debug
NODE_DEBUGGER_VERSION=v1.85.0
if [ ! -d $NODE_DEBUGGER_PATH ];then
  mkdir -p $NODE_DEBUGGER_PATH
  wget https://github.com/microsoft/vscode-js-debug/releases/download/$NODE_DEBUGGER_VERSION/js-debug-dap-$NODE_DEBUGGER_VERSION.tar.gz -P $HOME
  tar xvfz $HOME/js-debug-dap-$NODE_DEBUGGER_VERSION.tar.gz -C $NODE_DEBUGGER_PATH
  rm -f $HOME/js-debug-dap-$NODE_DEBUGGER_VERSION.tar.gz
fi
