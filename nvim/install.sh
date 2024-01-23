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
  npm run build
fi

NODE_DEBUGGER_PATH=$HOME/.debuggers/vscode-js-debug
if [ ! -d $NODE_DEBUGGER_PATH ];then
  mkdir -p $NODE_DEBUGGER_PATH
  wget https://github.com/microsoft/vscode-js-debug/releases/download/v1.85.0/js-debug-dap-v1.85.0.tar.gz -p /tmp
  tar xvfz /tmp/js-debug-dap-v1.85.0.tar.gz -C $NODE_DEBUGGER_PATH
fi
