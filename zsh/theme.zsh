# The state file is authoritative; environment variables are only a shell snapshot.
theme() {
  python3 "$HOME/.dotfiles/plugins/dotfiles-alberto-chamorro/themes/theme.py" "$@"
  local result=$?
  _dotfiles_theme_env
  return $result
}

_dotfiles_theme_env() {
  local state="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles-theme/state.json"
  export DOTFILES_THEME_STATE="$state"
  if [[ -r "$state" ]]; then
    export DOTFILES_THEME=$(sed -n 's/.*"mode": "\([a-z]*\)".*/\1/p' "$state")
    export DOTFILES_THEME_LIGHT=$(sed -n 's/.*"light": "\([a-z-]*\)".*/\1/p' "$state")
  else
    export DOTFILES_THEME=auto
    export DOTFILES_THEME_LIGHT=xcode-light
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _dotfiles_theme_env
_dotfiles_theme_env
