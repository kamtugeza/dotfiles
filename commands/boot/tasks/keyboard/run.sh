#!/usr/bin/env bash

if [[ "${SYSTEM_NAME}" == "mac" ]]; then
  # ACHTUNG! Karabiner replaces the file symlink with a physical file every time
  # changes are made via the GUI.
  link "${DOTFILES_HOME}/configs/config/karabiner" "${XDG_CONFIG_HOME}/karabiner"
fi

