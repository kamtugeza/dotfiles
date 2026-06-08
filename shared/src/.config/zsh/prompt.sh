#!/usr/bin/env zsh

function update_git_status_prompt() {
  GIT_STATUS_PROMPT=""

  vcs_info

  [[ -n "${vcs_info_msg_0_}" ]] || return

  local branch_name="${vcs_info_msg_0_}"
  GIT_STATUS_PROMPT=" %F{yellow}git:(${branch_name}"

  if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
    local behind ahead
    read -r behind ahead <<<"$(git rev-list --left-right --count '@{u}...HEAD' 2>/dev/null)"

    [[ "${behind}" -gt 0 ]] && GIT_STATUS_PROMPT+="%F{red}-${behind}"
    [[ "${ahead}" -gt 0 ]] && GIT_STATUS_PROMPT+="%F{green}+${ahead}"
  fi

  GIT_STATUS_PROMPT+="%F{yellow})%f"
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

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'

autoload -Uz add-zsh-hook
add-zsh-hook precmd update_git_status_prompt
add-zsh-hook precmd update_prompt
