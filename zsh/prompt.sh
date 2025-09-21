#!/usr/bin/env zsh

source "$ZSH_CONFIG_HOME/git-status.sh"

setopt prompt_subst

function update_prompt() {
  PROMPT=""

  if [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    PROMPT+="%F{green}%n@%m%F{text}:%f "
  fi

  PROMPT+="%F{blue}%5~%f${GIT_STATUS_PROMPT}"
  PROMPT+=$'\n'
  PROMPT+="%F{green}%f "
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd update_prompt