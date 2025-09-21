#!/usr/bin/env bash

if ! has_command zsh; then
  if is_mac; then
    brew install zsh

  elif is_ubuntu; then
    sudo apt-get install zsh
  fi

  chsh -s "$(which zsh)"
fi

link "$MODULE_DIR/complition.sh" "$ZSH_CONFIG_HOME/complition.sh"
link "$MODULE_DIR/git-status.sh" "$ZSH_CONFIG_HOME/git-status.sh"
link "$MODULE_DIR/history.sh" "$ZSH_CONFIG_HOME/history.sh"
link "$MODULE_DIR/plugin-manager.sh" "$ZSH_CONFIG_HOME/plugin-manager.sh"
link "$MODULE_DIR/prompt.sh" "$ZSH_CONFIG_HOME/prompt.sh"
link "$MODULE_DIR/.zshrc" "$HOME/.zshrc"
