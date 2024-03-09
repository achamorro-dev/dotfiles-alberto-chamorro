# Link starship config
STARSHIP_CONFIG_FILE=~/.config/starship.toml
DOTFILES_STARSHIP_FILE=~/.dotfiles/plugins/dotfiles-alberto-chamorro/starship/config/starship.toml

rm -f ${STARSHIP_CONFIG_FILE}
ln -s ${DOTFILES_STARSHIP_FILE} ${STARSHIP_CONFIG_FILE}


