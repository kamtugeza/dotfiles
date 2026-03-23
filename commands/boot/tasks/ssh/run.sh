#!/usr/bin/env bash

SSH_HOME="${HOME}/.ssh"
SSH_KEY="${SSH_HOME}/id_ed25519"

if [[ ! -f "${SSH_KEY}" ]]; then
  log_warn "ssh: ${SSH_KEY} not found"

  if ssh-keygen -t ed25519 -a 100 -f "${SSH_KEY}" -C "$(whoami)@$(hostname)" < /dev/tty; then
    log_success "ssh-keygen: add this public key to providers:"
    gum style --foreground 212 --border normal --padding "0 1" < "${SSH_KEY}.pub"
  else
    log_error "ssh-keygen: failed or was interrupted."
  fi
fi
