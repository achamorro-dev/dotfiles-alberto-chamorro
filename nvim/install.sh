# Download and install Nerd Font
curl -L -o ~/Downloads/nerd-fonts.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/3270.zip
mkdir -p ~/Downlodas/nerd-fonts
unzip ~/Downloads/nerd-fonts.zip -d ~/Downlodas/nerd-fonts
cp ~/Downlodas/nerd-fonts/*.ttf ~/Library/Fonts
rm -rf ~/Downlodas/nerd-fonts*


# Copy nvim config
rm -rf ~/.config/nvim
ln -s ~/.dotfiles/plugins/dotfiles-alberto-chamorro/nvim/config/nvim ~/.config/nvim
