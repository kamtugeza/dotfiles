#!/usr/bin/env bash

set -euo pipefail

MODULE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_HOME="$(cd -- "${MODULE_DIR}/.." && pwd -P)"

source "${DOTFILES_HOME}/shared/src/.exports"
source "${DOTFILES_HOME}/utils/logger.sh"
source "${DOTFILES_HOME}/utils/misc.sh"
source "${MODULE_DIR}/deps.sh"

read_args "$@"

if $DEBUG; then
  set -x
fi







log_info "update dependencies"







log_task_start "dependencies"

sudo pacman -Syu --needed --noconfirm "${pacman_deps[@]}"
yay -S --needed --noconfirm "${yay_deps[@]}"

log_task_finish "dependencies"







log_task_start "shells"

install_git_deps shared_shell_deps

log_task_finish "shells"







log_task_start "antivirus"

sudo systemctl stop clamav-freshclam.service
sudo freshclam
sudo systemctl start clamav-freshclam.service

log_task_finish "antivirus"







log_task_start "nodejs"

pnpm config set global-bin-dir "${NVM_BIN}"
pnpm config set global-dir "$(dirname "${NVM_BIN}")/pnpm-global"

pnpm add -g "${shared_node_deps[@]}"

log_task_finish "nodejs"







log_task_start "pi"

pi install "${shared_pi_deps[@]}"

log_task_finish "pi"







log_success "done"
