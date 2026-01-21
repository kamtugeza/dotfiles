#!/usr/bin/env bash

set -euo pipefail

source "${DOTFILES_HOME}/utils/file-system.sh"
source "${DOTFILES_HOME}/utils/misc.sh"
source "${DOTFILES_HOME}/utils/prompt.sh"

# Directories
dirs=(
    "${XDG_BIN_HOME}"
    "${XDG_CACHE_HOME}"
    "${XDG_CONFIG_HOME}"
    "${XDG_DATA_HOME}"
    "${XDG_LIB_HOME}"
    "${XDG_OPT_HOME}"
    "${XDG_STATE_HOME}"
    "${ZSH_CONFIG_HOME}"
)

make_dir "${dirs[@]}"

# Appearance
FONTS_DIR="$HOME/Library/Fonts"

for font_path in "${TASK_PATH}"/fonts/*.ttf; do
  font_name=$(basename "${font_path}")
  cp "${font_path}" "${FONTS_DIR}/${font_name}"
  log_info "cp: ${font_path/#$HOME/~} -> ${FONTS_DIR/#$HOME/~}/${font_name}"
done

# Network
COMPUTER_NAME=$(ask_plain "device-name" "What is your device name?")
if [[ ${COMPUTER_NAME} != $(scutil --get ComputerName) ]]; then
  sudo scutil --set ComputerName "${COMPUTER_NAME}"
fi

HOST_NAME=$(ask_plain "host-name" "What is your host name?")
if [[ ${HOST_NAME} != $(scutil --get HostName) ]]; then
  sudo scutil --set LocalHostName "${HOST_NAME}"
  sudo scutil --set HostName "${HOST_NAME}"
fi

# Dependencies
if ! has_command brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ "${UPDATE_PKG}" == "true" ]]; then
  brew update
  brew upgrade
fi

has_cask betterdisplay || brew install --cask betterdisplay
has_cask chatgpt || brew install --cask chatgpt
has_cask google-chrome || brew install --cask google-chrome
has_cask obsidian || brew install --cask obsidian

has_command gum || brew install gum

