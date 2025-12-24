# Link Cursor settings
CURSOR_USER_PATH="$HOME/Library/Application Support/Cursor/User"
DOTFILES_CURSOR_PATH="$HOME/.dotfiles/plugins/dotfiles-alberto-chamorro/cursor"
DOTFILES_CURSOR_USER_PATH="$DOTFILES_CURSOR_PATH/User"
SETTINGS_FILENAME="settings.json"
KEYBINDINGS_FILENAME="keybindings.json"

# Create the directory if it doesn't exist
mkdir -p "$CURSOR_USER_PATH"

# Remove the application files if they exist
rm -rf "$CURSOR_USER_PATH/${SETTINGS_FILENAME}"
rm -rf "$CURSOR_USER_PATH/${KEYBINDINGS_FILENAME}"

# Link files
ln -s $DOTFILES_CURSOR_USER_PATH/${SETTINGS_FILENAME} "$CURSOR_USER_PATH/${SETTINGS_FILENAME}"
ln -s $DOTFILES_CURSOR_USER_PATH/${KEYBINDINGS_FILENAME} "$CURSOR_USER_PATH/${KEYBINDINGS_FILENAME}"

# Cursor CLI
curl https://cursor.com/install -fsS | bash

# Install extensions
cat $DOTFILES_CURSOR_PATH/cursor_extensions.txt | xargs -L 1 cursor --install-extension
