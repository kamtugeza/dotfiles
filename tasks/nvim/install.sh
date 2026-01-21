#!/usr/bin/env bash

set -euo pipefail

source "${DOTFILES_HOME}/utils/file-system.sh"
source "${DOTFILES_HOME}/utils/misc.sh"

has_command codebook-lsp || brew install codebook-lsp
has_command nvim || brew install neovim
has_command rg || brew install ripgrep

link "${TASK_PATH}/lua" "${XDG_CONFIG_HOME}/nvim/lua"
link "${TASK_PATH}/init.lua" "${XDG_CONFIG_HOME}/nvim/init.lua"
