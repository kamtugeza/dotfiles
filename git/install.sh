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

cp "$GIT_PERSONAL_PATH.example" "$GIT_PERSONAL_PATH"

input_var "GIT_USER_FULL_NAME" "Git: What is your full name?" "User name"
input_var "GIT_USER_EMAIL" "Git: What is your email address?" "User email"

sed -i \
  -e "s|{{USER_FULL_NAME}}|$GIT_USER_FULL_NAME|g" \
  -e "s|{{USER_EMAIL}}|$GIT_USER_EMAIL|g" \
  "$GIT_PERSONAL_PATH"

link "$GIT_PERSONAL_PATH" "$XDG_CONFIG_HOME/git/personal"
