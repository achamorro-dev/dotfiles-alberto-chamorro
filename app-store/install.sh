if test "$(uname)" = "Darwin"; then
  read -p "¿Estás usando tu cuenta personal de App Store? (y/n): " personal_account
  if [ "$personal_account" = "y" ]; then
    # Xcode
    mas install 497799835
    # DemoPRO
    mas install 1384206666
  fi
fi
