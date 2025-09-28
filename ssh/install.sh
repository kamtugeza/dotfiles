#!/usr/bin/env bash

# Dependent on: git

if ! ssh-add -l >/dev/null 2>&1; then
  info "Starting SSH agent..."
  eval "$(ssh-agent -s)"
fi

SSH_CONFIG_PATH="$MODULE_DIR/config"

if [[ -f "$SSH_CONFIG_PATH" ]]; then
  rm "$SSH_CONFIG_PATH" 
fi

cp "$SSH_CONFIG_PATH.example" "$SSH_CONFIG_PATH"

GIT_SSH_KEY=$(gum input --placeholder "SSH: Where is your Git private key located? (absolute path)")

if [[ -z "$GIT_SSH_KEY" ]]; then
  err "Invalid path!"
  exit 1
fi

info "Git SSH key: $GIT_SSH_KEY"

if [[ ! -f "$GIT_SSH_KEY" ]]; then
  info "The file '$GIT_SSH_KEY' does not exist."
  
  if gum confirm "Do you want to generate a new SSH key?"; then
    ssh-keygen -t ed25519 -C "$GIT_USER_EMAIL" -f "$GIT_SSH_KEY"
    ssh-add "$GIT_SSH_KEY"
    info "SSH key generated at $GIT_SSH_KEY"

  else
    err "SSH key not found and not created."
    exit 1
  fi
fi

sed -i \
  -e "s|{{GIT_SSH_KEY}}|$GIT_SSH_KEY|g" \
  "$SSH_CONFIG_PATH"

link "$SSH_CONFIG_PATH" "$HOME/.ssh/config"
