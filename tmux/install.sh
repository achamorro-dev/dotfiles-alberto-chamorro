# Install tmux package manager
TPM_DIRECTORY=~/.tmux/plugins/tpm 
if [[ ! -d $TPM_DIRECTORY ]];then
  git clone https://github.com/tmux-plugins/tpm $TPM_DIRECTORY
fi

# Copy tmux config
rm -rf ~/.config/tmux ~/.tmux.conf
ln -s ~/.dotfiles/plugins/dotfiles-alberto-chamorro/tmux/config/tmux/tmux.conf ~/.tmux.conf
