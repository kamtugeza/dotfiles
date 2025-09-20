setopt PROMPT_SUBST

build_git_status() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    print ""
    return 0
  fi

  local branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  local upstream=$(git rev-parse --abbrev-ref @{u} 2>/dev/null)
  local ahead=0
  local behind=0

  if [[ -z "$upstream" ]]; then
    ahead=$(git rev-list --count HEAD --not --remotes 2>/dev/null)
  else
    local counts=$(git rev-list --left-right --count "$branch_name...$upstream" 2>/dev/null)
    ahead=$(echo "$counts" | awk '{print $1}')
    behind=$(echo "$counts" | awk '{print $2}')
  fi

  local branch_status=""

  if [[ "$behind" -gt 0 ]]; then
    branch_status+="$F{red}-$behind%f"
  fi

  if [[ "$ahead" -gt 0 ]]; then
    branch_status+="%F{green}+$ahead%f"
  fi

  print " %F{yellow}git:($branch_name%f$branch_status%F{yellow})%f"
}


build_prompt() {
  if [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    local prompt_user_host="%F{green}%n@%m%F{text}:%f "
  fi

  local git="$(build_git_status)"
  local prompt_dir="%F{blue}%5~%f"
  local prompt_command="%F{green}%f "

  print -- "${prompt_user_host:-}${prompt_dir}${git}\n${prompt_command}"
}

PROMPT='$(build_prompt)'
