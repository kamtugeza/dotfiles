#!/usr/bin/env bash

if ! has_command nvim; then
  if is_mac; then
    brew install neovim
  fi

  if is_ubuntu; then 
    sudo apt-get install neovim
  fi
fi

link "$MODULE_DIR/init.lua" "$XDG_CONFIG_HOME/nvim/init.lua"
