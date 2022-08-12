# Download and install Nerd Font
COUNT_NERD_FONTS=`ls -1 ~/Library/Fonts/3270* | wc -l`
if [ $COUNT_NERD_FONTS -eq 0 ]
then
  curl -L -o ~/Downloads/nerd-fonts.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/3270.zip
  mkdir -p ~/Downlodas/nerd-fonts
  unzip ~/Downloads/nerd-fonts.zip -d ~/Downlodas/nerd-fonts
  cp ~/Downlodas/nerd-fonts/*.ttf ~/Library/Fonts
  rm -rf ~/Downlodas/nerd-fonts*
fi

# Copy nvim config
rm -rf ~/.config/nvim
ln -s ~/.dotfiles/plugins/dotfiles-alberto-chamorro/nvim/config/nvim ~/.config/nvim
