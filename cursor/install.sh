# Link Cursor settings
CURSOR_USER_PATH="$HOME/Library/Application Support/Cursor/User"
DOTFILES_CURSOR_USER_PATH="$HOME/.dotfiles/plugins/dotfiles-alberto-chamorro/cursor/User"
SETTINGS_FILENAME="settings.json"
SHORTCUTS_FILENAME="shortcuts.json"

# Create the directory if it doesn't exist
mkdir -p "$CURSOR_USER_PATH"

# Remove the application files if they exist
rm -rf "$CURSOR_USER_PATH/${SETTINGS_FILENAME}"
rm -rf "$CURSOR_USER_PATH/${SHORTCUTS_FILENAME}"

# Link files
ln -s $DOTFILES_CURSOR_USER_PATH/${SETTINGS_FILENAME} "$CURSOR_USER_PATH/${SETTINGS_FILENAME}"
ln -s $DOTFILES_CURSOR_USER_PATH/${SHORTCUTS_FILENAME} "$CURSOR_USER_PATH/${SHORTCUTS_FILENAME}"
