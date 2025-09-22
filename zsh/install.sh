#!/usr/bin/env bash

if ! has_command zsh; then
  if is_mac; then
    brew install zsh

  elif is_ubuntu; then
    sudo apt-get install zsh
  fi

  chsh -s "$(which zsh)"
fi

if ! has_command fzf; then
  brew install fzf
fi

if ! has_command z; then
  brew install zoxide
fi

link "$MODULE_DIR/complition.sh" "$ZSH_CONFIG_HOME/complition.sh"
link "$MODULE_DIR/history.sh" "$ZSH_CONFIG_HOME/history.sh"
link "$MODULE_DIR/prompt.sh" "$ZSH_CONFIG_HOME/prompt.sh"
link "$MODULE_DIR/.zshrc" "$HOME/.zshrc"
