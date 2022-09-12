# Move next only if `homebrew` is installed
if command -v brew >/dev/null 2>&1; then
	# Load rupa's z if installed
	if [ -f $(brew --prefix)/etc/profile.d/z.sh ];then
	  source $(brew --prefix)/etc/profile.d/z.sh
	fi
fi
