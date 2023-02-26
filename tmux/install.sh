# Install tmux package manager
TPM_DIRECTORY=~/.tmux/plugins/tpm 
if [[ ! -d $TPM_DIRECTORY ]];then
  git clone https://github.com/tmux-plugins/tpm $TPM_DIRECTORY
fi

# Link tmux config
TMUX_CONFIG_DIRECTORY=~/.config/tmux
DOTFILES_TMUX_DIRECTORY=~/.dotfiles/plugins/dotfiles-alberto-chamorro/tmux/config/tmux

rm -f ${TMUX_CONFIG_DIRECTORY} ~/.config/tmux.conf
ln -s ${DOTFILES_TMUX_DIRECTORY} ${TMUX_CONFIG_DIRECTORY}

