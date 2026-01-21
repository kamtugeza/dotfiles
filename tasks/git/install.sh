#!/usr/bin/env bash

set -euo pipefail

source "${DOTFILES_HOME}/utils/file-system.sh"
source "${DOTFILES_HOME}/utils/misc.sh"
source "${DOTFILES_HOME}/utils/prompt.sh"

has_command git || brew install git

# Forces XDG config
if [[ -f "${HOME}/.gitconfig" ]]; then
  backup "${HOME}/.gitconfig"
  rm "${HOME}/.gitconfig"
fi

link "${TASK_PATH}/config" "${XDG_CONFIG_HOME}/git/config"

PERSONAL_PATH="${XDG_CONFIG_HOME}/git/personal"
backup "${PERSONAL_PATH}"
> "${PERSONAL_PATH}"

git config --file "${PERSONAL_PATH}" user.name "$(ask_plain "git-user-name" "What is your full name?")"
git config --file "${PERSONAL_PATH}" user.email "$(ask_plain "git-user-email" "What is your email?")"
