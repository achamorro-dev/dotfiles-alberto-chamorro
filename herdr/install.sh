# Install herdr if the command is not available
if ! command -v herdr >/dev/null 2>&1; then
  curl -fsSL https://herdr.dev/install.sh | sh
fi

# Seed a local config only when missing. Theme colors are merged into the local
# file by theme install; keep this versioned template free of generated palettes.
HERDR_CONFIG_DIR=~/.config/herdr
HERDR_CONFIG_FILE=${HERDR_CONFIG_DIR}/config.toml
DOTFILES_HERDR_FILE=~/.dotfiles/plugins/dotfiles-alberto-chamorro/herdr/config/config.toml

mkdir -p "${HERDR_CONFIG_DIR}"
if [ ! -e "${HERDR_CONFIG_FILE}" ]; then
  cp "${DOTFILES_HERDR_FILE}" "${HERDR_CONFIG_FILE}"
fi
