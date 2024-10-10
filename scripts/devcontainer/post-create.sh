#!/bin/zsh

cat >> ~/.zshrc <<EOF

git() {
  if [[ \$# -ge 1 && "\$1" == "status" ]]; then
    echo "========= Run git stash list ========="
    var=\$(git stash list 2>&1)
    echo -e "\033[35m \$var \e[0m"
    echo "========= End git stash list ========="
    command git status
  else
    command git "\$@"
  fi
}

alias gps='git push origin HEAD'
alias gpl='git pull origin \$(git rev-parse --abbrev-ref HEAD)'

EOF

if [ -x "$(command -v terraform --version)" ]; then
  terraform -install-autocomplete
fi
