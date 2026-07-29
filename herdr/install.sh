# Install herdr if the command is not available
if ! command -v herdr >/dev/null 2>&1; then
  curl -fsSL https://herdr.dev/install.sh | sh
fi

# Link herdr config
HERDR_CONFIG_DIR=~/.config/herdr
HERDR_CONFIG_FILE=${HERDR_CONFIG_DIR}/config.toml
DOTFILES_HERDR_FILE=~/.dotfiles/plugins/dotfiles-alberto-chamorro/herdr/config/config.toml

mkdir -p ${HERDR_CONFIG_DIR}
rm -f ${HERDR_CONFIG_FILE}
ln -s ${DOTFILES_HERDR_FILE} ${HERDR_CONFIG_FILE}
