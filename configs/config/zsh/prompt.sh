#!/usr/bin/env zsh

# See more: https://github.com/romkatv/gitstatus/blob/master/gitstatus.prompt.zsh
function update_git_status_prompt() {
  gitstatus_query 'MY'
  GIT_STATUS_PROMPT=""

  if [[ -n "${VCS_STATUS_LOCAL_BRANCH}" ]]; then
    GIT_STATUS_PROMPT=" %F{yellow}git:(${VCS_STATUS_LOCAL_BRANCH}"
    
    if [[ "${VCS_STATUS_COMMITS_BEHIND}" -gt 0 ]]; then
      GIT_STATUS_PROMPT+="%F{red}-${VCS_STATUS_COMMITS_BEHIND}"
    fi
    
    if [[ "${VCS_STATUS_COMMITS_AHEAD}" -gt 0 ]]; then
      GIT_STATUS_PROMPT+="%F{green}+${VCS_STATUS_COMMITS_AHEAD}"
    fi
    
    GIT_STATUS_PROMPT+="%F{yellow})%f"
  fi
}

function update_prompt() {
  PROMPT=$'\n'

  if [[ -n "${SSH_CONNECTION}" || -n "${SSH_CLIENT}" || -n "${SSH_TTY}" ]]; then
    PROMPT+="%F{green}%n@%m%F{text}:%f "
  fi

  PROMPT+="%F{blue}%5~%f${GIT_STATUS_PROMPT}"
  PROMPT+=$'\n'
  PROMPT+="%F{green}❭%f "
}

setopt prompt_subst

zinit light romkatv/gitstatus

gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'

autoload -Uz add-zsh-hook
add-zsh-hook precmd update_git_status_prompt
add-zsh-hook precmd update_prompt
