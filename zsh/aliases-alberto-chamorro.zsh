## PATHS
alias w="cd $HOME/workspace"

## COMMANDS
alias c="clear"
alias co="code ."
alias h="history -10000 | fzf --reverse"
alias g="lazygit"

# NPM
alias ns="npm run serve"
alias nst="npm run start"
alias nd="npm run dev"
alias ni="npm i"
alias nci="npm ci"
alias nr="npm run"

# IDE
alias i="idea"
alias ws="webstorm"
alias st="studio"
alias n="nvim"
alias vim="nvim"
alias vi="nvim"

# TMUX
alias t="tmux"
alias ta="tmux a -t"
alias tls="tmux ls"
alias tn="tmux new -t"
alias tk="tmux kill-session -t"

# EXA
alias ll="exa -l -g --icons --git"
alias llt="exa -1 --icons --tree --git-ignore"

# Chrome CORS disabled
alias ccors="open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir=\"/tmp/chrome_dev_test\" --disable-web-security"
