#!/usr/bin/env bash

set -euo pipefail

source "${DOTFILES_HOME}/utils/file-system.sh"
source "${DOTFILES_HOME}/utils/misc.sh"

if ! has_command zsh; then
  brew install zsh
  chsh -s "$(which zsh)"
fi

has_command fzf || brew install fzf
has_command zoxide || brew install zoxide

link "${DOTFILES_HOME}/shared/.exports" "${HOME}/.exports"
link "${TASK_PATH}/.zshrc" "${HOME}/.zshrc"
link "${TASK_PATH}/completion.sh" "${ZSH_CONFIG_HOME}/completion.sh"
link "${TASK_PATH}/history.sh" "${ZSH_CONFIG_HOME}/history.sh"
link "${TASK_PATH}/prompt.sh" "${ZSH_CONFIG_HOME}/prompt.sh"
