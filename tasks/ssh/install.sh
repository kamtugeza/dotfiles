#!/usr/bin/env bash

set -euo pipefail

source "${DOTFILES_HOME}/utils/file-system.sh"
source "${DOTFILES_HOME}/utils/logger.sh"

SSH_HOME="${HOME}/.ssh"
PERSONAL_KEY="${SSH_HOME}/theoleksii"

mkdir -p "${SSH_HOME}"
link "${TASK_PATH}/config" "${SSH_HOME}/config"

if [[ ! -f "${PERSONAL_KEY}" ]]; then
  log_warn "ssh: ${PERSONAL_KEY} not found"

  if ssh-keygen -t ed25519 -f "${PERSONAL_KEY}" -C "$(whoami)@$(hostname)"; then
    log_info "ssh-keygen: add this public key to providers:"
    gum style --foreground 212 --border normal --padding "0 1" < "${PERSONAL_KEY}.pub"
  else
    log_error "ssh-keygen: failed or was interrupted."
  fi
fi
