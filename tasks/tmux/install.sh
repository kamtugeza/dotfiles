#!/usr/bin/env bash

set -euo pipefail

source "${DOTFILES_HOME}/utils/file-system.sh"
source "${DOTFILES_HOME}/utils/misc.sh"

has_command tmux || brew install tmux

link "${TASK_PATH}/tmux.conf" "${XDG_CONFIG_HOME}/tmux/tmux.conf"
