#!/usr/bin/env bash

set -euo pipefail

source "${DOTFILES_HOME}/utils/file-system.sh"
source "${DOTFILES_HOME}/utils/misc.sh"

has_cask zed || brew install --cask zed

