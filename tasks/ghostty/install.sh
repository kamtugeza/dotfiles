#!/usr/bin/env bash

set -euo pipefail

source "${DOTFILES_HOME}/utils/file-system.sh"
source "${DOTFILES_HOME}/utils/misc.sh"

has_cask ghostty || brew install --cask ghostty

link "${TASK_PATH}/config" "${XDG_CONFIG_HOME}/ghostty/config"
