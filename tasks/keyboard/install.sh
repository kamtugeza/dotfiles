#!/usr/bin/env bash

set -euo pipefail

source "${DOTFILES_HOME}/utils/file-system.sh"
source "${DOTFILES_HOME}/utils/misc.sh"

has_cask karabiner-elements || brew install --cask karabiner-elements

# ACHTUNG! Karabiner replaces the file symlink with a physical file every time
# changes are made via the GUI.
link "${TASK_PATH}/karabiner" "${XDG_CONFIG_HOME}/karabiner"

