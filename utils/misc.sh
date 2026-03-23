source "$DOTFILES_HOME/utils/logger.sh"

has_command() {
  local cmd="${1:-}"

  if [[ -z "${cmd}" ]]; then
    log_err "has_command: no command name provided"
    return 1
  fi
  
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    log_warn "has_command: ${cmd}: command not found"
    return 1
  fi

  return 0
}

