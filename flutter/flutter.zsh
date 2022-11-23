export PATH="$HOME/fvm/default/bin":"$HOME/.pub-cache/bin":$PATH

alias fd="flutter devices"
alias frd="flutter run --flavor development -t lib/main_development.dart"
alias frs="flutter run --flavor staging -t lib/main_staging.dart"
alias frp="flutter run --flavor production -t lib/main_production.dart"
alias frb="flutter pub run build_runner build"

