#!/usr/bin/env bash

# Forces XDG config
if [[ -f "${HOME}/.gitconfig" ]]; then
  backup "${HOME}/.gitconfig"
fi

link "${DOTFILES_HOME}/configs/config/git/config" "${XDG_CONFIG_HOME}/git/config"

PERSONAL_PATH="${XDG_CONFIG_HOME}/git/personal"
backup "${PERSONAL_PATH}"
> "${PERSONAL_PATH}"

USER_NAME=$(ask_plain "git-user-name" "What is your full name?" "" 1)
USER_EMAIL=$(ask_plain "git-user-email" "What is your email?" "" 1)

git config --file "${PERSONAL_PATH}" user.name "${USER_NAME}"
git config --file "${PERSONAL_PATH}" user.email "${USER_EMAIL}"
