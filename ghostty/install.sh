# Link Cursor settings
GHOSTTY_HOME_PATH="$HOME/.config/ghostty"
GHOSTTY_CONFIG_PATH="$HOME/Library/Application Support/com.mitchellh.ghostty"
GHOSTTY_THEMES_PATH="$GHOSTTY_HOME_PATH/themes"
DOTFILES_GHOSTTY_CONFIG_PATH="$HOME/.dotfiles/plugins/dotfiles-alberto-chamorro/ghostty/setup"
DOTFILES_GHOSTTY_THEMES_PATH="$HOME/.dotfiles/plugins/dotfiles-alberto-chamorro/ghostty/setup/themes"
SETTINGS_FILENAME="config"

# Create the directory if it doesn't exist
mkdir -p "$GHOSTTY_CONFIG_PATH"
mkdir -p "$GHOSTTY_HOME_PATH"

# Remove the application files if they exist
rm -rf "$GHOSTTY_CONFIG_PATH/${SETTINGS_FILENAME}"

# Link files
ln -s $DOTFILES_GHOSTTY_CONFIG_PATH/${SETTINGS_FILENAME} "$GHOSTTY_CONFIG_PATH/${SETTINGS_FILENAME}"
ln -s "$DOTFILES_GHOSTTY_THEMES_PATH" "$GHOSTTY_THEMES_PATH"
