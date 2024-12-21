if test "$(uname)" = "Darwin"; then
	read -p "¿Estás usando tu cuenta personal de App Store? (y/n): " personal_account
	if [ "$personal_account" = "y" ]; then
		# Tomito
		mas install 1526042938
		# Xcode
		mas install 497799835
		# Unsplash Wallpapers
		# mas install 1284863847
		# DemoPRO
		mas install 1384206666
	fi
fi
