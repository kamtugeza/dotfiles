#!/usr/bin/env bash

set -euo pipefail

source "${DOTFILES_HOME}/utils/file-system.sh"
source "${DOTFILES_HOME}/utils/misc.sh"

has_cask visual-studio-code || brew install --cask visual-studio-code

link "${TASK_PATH}/User/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"

has_extension() {
  code --list-extensions | grep -q "${1}"
}

has_extension jdinhlife.gruvbox || code --install-extension jdinhlife.gruvbox
has_extension pkief.material-icon-theme || code --install-extension pkief.material-icon-theme
has_extension streetsidesoftware.code-spell-checker || code --install-extension streetsidesoftware.code-spell-checker
has_extension vscodevim.vim || code --install-extension vscodevim.vim
