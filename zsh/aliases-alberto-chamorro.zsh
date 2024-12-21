## PATHS
alias w="cd $HOME/workspace"

## COMMANDS
alias c="clear"
alias g="lazygit"
alias o="open ."

# NPM
alias n="npm"
alias ns="npm run serve"
alias nst="npm run start"
alias nd="npm run dev"
alias nb="npm run build"
alias np="npm run preview"
alias ni="npm i"
alias nci="npm ci"
alias nr="npm run"
alias p="pnpm"
alias pi="pnpm i"
alias pa="pnpm add"
alias pst="pnpm start"
alias pd="pnpm dev"
alias pb="pnpm build"
alias pr="pnpm run"
alias px="pnpx"

# Flutter
alias f="flutter"
alias fg="flutter pub get"
alias fpc="flutter pub cache clean"
alias fc="flutter clean"
alias fb="flutter run build_runner build"

# IDE
alias i="idea"
alias ws="webstorm"
alias st="studio"
alias v="nvim"
alias vim="nvim"
alias vi="nvim"
alias co="code"

# TMUX
alias t="tmux"
alias ta="tmux a -t"
alias tls="tmux ls"
alias tn="tmux new -t"
alias tk="tmux kill-session -t"

# LS
alias l="ls -a | fzf"
alias ll="ls -ltr"
alias lla="ls -ltra"

# Chrome CORS disabled
alias ccors="open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir=\"/tmp/chrome_dev_test\" --disable-web-security"

# Movements
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../.."
alias h="cd $HOME"
