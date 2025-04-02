# Link sketchybar config
rm -rf ~/.config/sketchybar
mkdir -p ~/.config
ln -s ~/.dotfiles/plugins/dotfiles-alberto-chamorro/sketchybar/config ~/.config/sketchybar

# Start
brew services start sketchybar

