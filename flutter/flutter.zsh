export PATH="$HOME/fvm/default/bin":"$HOME/.pub-cache/bin":$PATH

alias fld="flutter devices"
alias flrd="flutter run --flavor development -t lib/main_development.dart"
alias flrs="flutter run --flavor staging -t lib/main_staging.dart"
alias flrp="flutter run --flavor production -t lib/main_production.dart"
alias flrb="flutter pub run build_runner build"

