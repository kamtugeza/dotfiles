#!/usr/bin/env bash

set -euo pipefail

source "${DOTFILES_HOME}/utils/file-system.sh"
source "${DOTFILES_HOME}/utils/misc.sh"

has_command opencode || brew install anomalyco/tap/opencode

link "${TASK_PATH}/opencode.json" "${XDG_CONFIG_HOME}/opencode/opencode.json"

