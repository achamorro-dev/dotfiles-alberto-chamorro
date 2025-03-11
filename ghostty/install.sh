# Link Cursor settings
GHOSTTY_CONFIG_PATH="$HOME/Library/Application Support/com.mitchellh.ghostty"
DOTFILES_GHOSTTY_CONFIG_PATH="$HOME/.dotfiles/plugins/dotfiles-alberto-chamorro/ghostty/setup"
SETTINGS_FILENAME="config"

# Create the directory if it doesn't exist
mkdir -p "$GHOSTTY_CONFIG_PATH"

# Remove the application files if they exist
rm -rf "$GHOSTTY_CONFIG_PATH/${SETTINGS_FILENAME}"

# Link files
ln -s $DOTFILES_GHOSTTY_CONFIG_PATH/${SETTINGS_FILENAME} "$GHOSTTY_CONFIG_PATH/${SETTINGS_FILENAME}"
