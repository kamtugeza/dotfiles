#!/usr/bin/env bash

if ! has_command git; then
  if is_mac; then
    brew install git
  
  elif is_ubuntu; then 
    sudo apt-get install git
  fi
fi

# Forces XDG config
if [[ -f "$HOME/.gitconfig" ]]; then
  backup "$HOME/.gitconfig"
  rm "$HOME/.gitconfig"
fi

link "$MODULE_DIR/config" "$XDG_CONFIG_HOME/git/config"

GIT_PERSONAL_PATH="$MODULE_DIR/personal"

if [[ -f "$GIT_PERSONAL_PATH" ]]; then
  rm "$GIT_PERSONAL_PATH" 
fi

cp "$MODULE_DIR/personal.example" "$GIT_PERSONAL_PATH"

USER_NAME=$(gum input --placeholder "Git: What is your full name?")

if [[ -z "$USER_NAME" ]]; then
  err "Invalid name!"
  exit 1
fi

info "User name: $USER_NAME"

USER_EMAIL=$(gum input --placeholder "Git: What is your email address?")

if [[ -z "$USER_EMAIL" ]]; then
  err "Invalid email!"
  exit 1
fi

info "User email: $USER_EMAIL"

sed -i "s/USER_NAME/$USER_NAME/g" "$GIT_PERSONAL_PATH"
sed -i "s/USER_EMAIL/$USER_EMAIL/g" "$GIT_PERSONAL_PATH"

link "$GIT_PERSONAL_PATH" "$XDG_CONFIG_HOME/git/personal"
