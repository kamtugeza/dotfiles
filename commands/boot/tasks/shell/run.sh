#!/usr/bin/env bash

if [[ "${SHELL}" != "/usr/bin/zsh" ]]; then
  if ! chsh -s "$(which zsh)" < /dev/tty; then
    log_err "chsh: failed to change shell"
  else
    log_success "chsh: configured ZSH as default shell"
  fi
fi

link "${DOTFILES_HOME}/configs/exports" "${HOME}/.exports"
link "${DOTFILES_HOME}/configs/zshrc" "${HOME}/.zshrc"
link "${DOTFILES_HOME}/configs/config/zsh/completion.sh" "${ZSH_CONFIG_HOME}/completion.sh"
link "${DOTFILES_HOME}/configs/config/zsh/history.sh" "${ZSH_CONFIG_HOME}/history.sh"
link "${DOTFILES_HOME}/configs/config/zsh/prompt.sh" "${ZSH_CONFIG_HOME}/prompt.sh"
