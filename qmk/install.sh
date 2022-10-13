QMK_DIRECTORY=$HOME/qmk_firmware

if [ ! -d $QMK_DIRECTORY ];then
  qmk setup
fi

# Copy qmk keymaps
rm -rf ~/qmk_firmware/keyboards/crkbd/keymaps/achamorro-dev
ln -s ~/.dotfiles/plugins/dotfiles-alberto-chamorro/qmk/keymaps/achamorro-dev ~/qmk_firmware/keyboards/crkbd/keymaps/achamorro-dev

