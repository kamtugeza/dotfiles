#!/usr/bin/env bash

if ! has_command tmux; then
  if is_mac; then
    brew install tmux
  elif is_ubuntu; then
    sudo apt-get install tmux
  fi
fi

link "$MODULE_DIR/.tmux.conf" "$HOME/.tmux.conf"
